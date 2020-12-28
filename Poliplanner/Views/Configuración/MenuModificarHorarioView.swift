//
//  MenuArmarHorarioView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI
import UniformTypeIdentifiers
import RealmSwift

struct MenuModificarHorarioView: View {
    @ObservedObject var PPStore: PoliplannerStore = PoliplannerStore.shared
    @State private var estaImportando: Bool = false
    @State private var estaArmando: Bool = false

    var body: some View {
            Form {
                // MARK: - Crear horario
                Section(header: Text("Crear horario")) {
                    botonImportarArchivo
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
                
                print("Tiempo de importación: \(timeInterval) seconds")
                
                if horarioGenerado != nil {
                    DispatchQueue.main.sync {
                        // Pasamos al PPStore el draft del horario de clase en el hilo principal
                        // provocando una actualización en la interfaz gráfica
                        // Como no esta manejado por realm todavía, es seguro pasar entre hilos el objeto
                        PPStore.horarioClaseDraft = horarioGenerado!
                        estaArmando = true
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
                MenuModificarHorarioView()
                    .environmentObject(PoliplannerStore(realm: RealmProvider.realm()))
            }
        }
    }
}
