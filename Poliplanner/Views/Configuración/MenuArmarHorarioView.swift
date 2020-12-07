//
//  MenuArmarHorarioView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI
import UniformTypeIdentifiers
import RealmSwift

struct MenuArmarHorarioView: View {
    @ObservedObject var PPStore: PoliplannerStore = PoliplannerStore.shared
    @State private var estaImportando: Bool = false
    @State private var estaArmando: Bool = false

    var body: some View {
            Form {
                // MARK: - Crear horario
                Section(header: Text("Crear horario")) {
                    botonImportarArchivo
                }
                
                // MARK: - Armar horario desde un horario preexistente
                
                Section(header: Text("Armar horario")) {
                    if PPStore.hayHorario {
                        // TODO: Hacer el view de armar horario desde el horario actual
                        Text("Armar desde el horario de clases actual")
                        // TODO: Hacer el view de armar desde un horario ya importado
                        Text("Armar desde otro horario de clases")
                    } else {
                        Text("Armar desde el horario de clases actual")
                            .foregroundColor(.gray)
                        Text("Armar desde otro horario de clases")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationBarTitle("Modificar horario")
            .navigationBarTitleDisplayMode(.automatic)
            // MARK: - Importación del Archivo
            .fileImporter(isPresented: $estaImportando,
                          allowedContentTypes: [.xlsx, .xls], onCompletion: importarArchivo)
            .sheet(isPresented: $estaArmando) {
                NavigationView {
                    ArmarSeleccionarCarrera(estaPresentando: $estaArmando)
                }
            }
    }
    
    // MARK: - Boton Importar Archivo
    var botonImportarArchivo: some View {
            Button {
                self.estaImportando = true
            } label: {
                Text("Importar desde un archivo")
            }
        
    }
    
    // MARK: - Qué hacer con el archivo importado
    func importarArchivo(resultado: Result<URL, Error>) {
        switch resultado {
        case .success(let archivoURL):
            var parser: ArchivoHorarioParser
            
            switch UTType(filenameExtension: archivoURL.pathExtension) {
            case .some(.xlsx):
                parser = XLSXHorarioParser(archivoURL: archivoURL)
                print("Es un archivo nuevo")
            case .some(.xls):
                print("Es un archivo feo")
                return
            case .none:
                print("No se pudo obtener la extensión")
                return
            default:
                print("Se desconoce el archivo")
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let start = DispatchTime.now()
                let horarioGenerado = try? parser.generarHorario()
                let end = DispatchTime.now()
                
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                
                print("Time to evaluate problem: \(timeInterval) seconds")
                
                let realm = RealmProvider.realm()
                
                if horarioGenerado != nil {
                    try? realm.write {
                        realm.add(horarioGenerado!)
                    }
                }
                
                let horarioRef = ThreadSafeReference(to: horarioGenerado!)
                
                DispatchQueue.main.async {
                    autoreleasepool {
                        let realm = RealmProvider.realm()
                        realm.refresh()
                        guard let horarioDraft = realm.resolve(horarioRef) else {
                            return
                        }
                        self.PPStore.horarioClaseDraft = horarioDraft
                        self.estaArmando = true
                    }
                }
            }
            
        case .failure(let error):
            print("Hubo un error al importar. Error: \(error.localizedDescription)")
        }
    }
}

struct MenuArmarHorarioView_Previews: PreviewProvider {
    
    static var previews: some View {
        TabView {
            NavigationView {
                MenuArmarHorarioView()
                    .environmentObject(PoliplannerStore(realm: RealmProvider.realm()))
            }
        }
    }
}
