//
//  ArmarSeleccionarSecciones.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import SwiftUI

struct ArmarSeleccionarSecciones: View {
    // MARK: Propiedades
    
    /// VIew Model que controla este View
    @ObservedObject var viewModel: SeleccionarSeccionesViewModel
    
    /// ViewModel de los pasos del armado del horario
    @EnvironmentObject private var viewModelPasos: ArmarHorarioPasosViewModel
    
    init(materiasSeleccionadas: [CarreraSigla: Set<InfoAsignatura>]) {
        self.viewModel = SeleccionarSeccionesViewModel(materiasSeleccionadas: materiasSeleccionadas)
    }
    
    // MARK: Body
    
    var body: some View {
        Form {
            // Por cada materia
            ForEach(viewModel.seccionesAgrupadas) { grupo in
                Section {
                    DisclosureGroup("\(grupo.carrera.sigla) - \(grupo.infoAsignatura.nombre)") {
                        // Por cada sección
                        ForEach(grupo.secciones) { seccion in
                            // Indica si esta seleccionado
                            let seleccionado = viewModel.seccionesSeleccionadas.contains(seccion)
                            
                            // Botón de la sección
                            Button {
                                if seleccionado {
                                    viewModel.quitarSeccion(seccion)
                                } else {
                                    viewModel.agregarSeccion(seccion)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(seleccionado ? .blue : .gray)
                                    Text("\(seccion.codigo)")
                                    Text(seccion.docente)
                                        .font(.system(size: 16.0))
                                }
                                .foregroundColor(Color(.label))
                            }
                        }
                    } // Fin del Disclosure Group
                } // Fin del section
            }
        }
        .navigationBarTitle("Selecciones las secciones", displayMode: .inline)
        .navigationBarItems(leading: botonAtras, trailing: botonSiguiente)
    }
    
    var botonAtras: some View {
        Button("Atrás") {
            viewModelPasos.retroceder()
        }
    }
    
    /// View del Botón que hará que se cargue el horario de clases a la base de datos
    var botonSiguiente: some View {
        Button("Siguiente") {
            viewModelPasos.confirmarSecciones(secciones: viewModel.seccionesSeleccionadas)
        }.disabled(viewModel.seccionesAgrupadas.count != viewModel.seccionesSeleccionadas.count)
    }
}
