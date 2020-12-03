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
            .fileImporter(isPresented: $estaImportando, allowedContentTypes: [.xlsx, .xls]) { resultado in
                // TODO: Hacer algo con el archivo
                switch resultado {
                case .success(let archivoURL):
                    switch UTType(filenameExtension: archivoURL.pathExtension) {
                    case .some(.xlsx):
                        print("Es un archivo nuevo")
                    case .some(.xls):
                        print("Es un archivo feo")
                    case .none:
                        print("No se pudo obtener la extensión")
                    default:
                        print("Se desconoce el archivo")
                    }
                case .failure(let error):
                    print("Hubo un error al importar. Error: \(error.localizedDescription)")
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
