//
//  MenuArmarHorarioView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI
import UniformTypeIdentifiers
import RealmSwift
import TTProgressHUD

// MARK: Menu de Modificar Horarios

/// Interfaz del menu para modificar horarios.
/// Permite al usuario importar horarios y modificarlos.
struct MenuModificarHorarioView: View {
    // MARK: Propiedades
    
    @ObservedObject private var viewModel = MenuHorarioClasesViewModel()

    // MARK: Body
    
    var body: some View {
        ZStack {
            Form {
                // MARK: Crear horario
                Section(header: Text("Crear horario")) {
                    botonImportarArchivo
                }
                
                // MARK: Horarios Cargados
                Section(header: Text("Horarios de clases")) {
                    if viewModel.hayHorario {
                        ForEach(viewModel.horariosClase) { horario in
                            NavigationLink(
                                destination: InformacionHorarioView(horario)) {
                                Text(horario.nombre)
                            }
                        }
                    } else {
                        Text("No tienes horarios 😢")
                    }
                }
            }
            // MARK: Importación del Archivo
            .fileImporter(isPresented: $viewModel.estaImportando,
                          allowedContentTypes: [.xlsx, .xls],
                          onCompletion: viewModel.importarArchivo)
            // MARK: Presentar paso para seleccionar carreras
            .sheet(isPresented: $viewModel.estaArmando) {
                NavigationView {
                    ArmarHorarioPasosView(estaPresentando: $viewModel.estaArmando)
                }
            }
            // MARK: Progress View
            if viewModel.estaProcesando {
                TTProgressHUD($viewModel.estaProcesando, config: viewModel.hudConfig)
            }
        }
        .navigationBarTitle("Horarios de clases")
    }
    
    /// View de la opción para importar un archivo
    var botonImportarArchivo: some View {
        Button {
            viewModel.estaImportando = true
        } label: {
            Text("Importar desde un archivo")
        }
    }
}

// MARK: - Preview
#if DEBUG
/// :nodoc:
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
#endif
