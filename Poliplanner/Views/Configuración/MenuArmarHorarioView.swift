//
//  MenuArmarHorarioView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI
import UniformTypeIdentifiers

struct MenuArmarHorarioView: View {
    @EnvironmentObject var PPStore: PoliplannerStore
    @State private var estaImportando: Bool = false

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
    }
    
    // MARK: - Boton Importar Archivo
    var botonImportarArchivo: some View {
            Button {
                self.estaImportando = true
            } label: {
                Text("Importar desde un archivo")
            }
        
    }
    
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
                _ = try? parser.generarHorario()
                let end = DispatchTime.now()
                
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                
                print("Time to evaluate problem: \(timeInterval) seconds")
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
