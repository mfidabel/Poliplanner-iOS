//
//  ArmarSeleccionarCarrera.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-04.
//

import SwiftUI

// MARK: - Paso para seleccionar la carrera

/// View de la interfaz donde el usuario podrá seleccionar la carrera para seleccionar las materias
struct ArmarSeleccionarCarrera: View {
    // MARK: Propiedades
    
    /// ViewModel de esta view
    @ObservedObject private var viewModel = SeleccionarCarrerasViewModel()
    
    /// ViewModel de los pasos del armado del horario
    @EnvironmentObject private var viewModelPasos: ArmarHorarioPasosViewModel
    
    // MARK: Body
    
    var body: some View {
        Group {
            Form {
                ForEach(viewModel.carrerasDisponibles, id: \.self) { carrera in
                    // Propiedades de la celda
                    let seleccionado = viewModel.carrerasSeleccionadas.contains(carrera)
                    
                    // Botón
                    Button {
                        // Seleccionar/Deseleccionar
                        if seleccionado {
                            viewModel.eliminarCarrera(carrera)
                        } else {
                            viewModel.agregarCarrera(carrera)
                        }
                    } label: {
                        // Vista
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(seleccionado ? .blue : .gray)
                            Text("\(carrera.sigla) - \(carrera.nombreLargo)")
                        }
                        .foregroundColor(Color(.label))
                    }
                }
            }
            Spacer()
        }
        .navigationBarTitle("Seleccione las carreras", displayMode: .inline)
        .navigationBarItems(leading: botonCancelar, trailing: botonSiguiente)
        
    }
    
    /// View de un botón para cancelar la selección
    var botonCancelar: some View {
        Button("Cancelar") {
            viewModelPasos.cancelar()
        }
    }
    
    var botonSiguiente: some View {
        Button("Siguiente") {
            viewModelPasos.confirmarCarreras(carreras: Array(viewModel.carrerasSeleccionadas))
        }.disabled(viewModel.carrerasSeleccionadas.isEmpty)
    }
}

// MARK: - Preview
#if DEBUG
/// :nodoc:
struct ArmarSeleccionarCarrera_Previews: PreviewProvider {
    static var previews: some View {
        ArmarSeleccionarCarrera()
            .environmentObject(ArmarHorarioPasosViewModel(estaPresentando: .constant(true)))
    }
}
#endif
