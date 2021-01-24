//
//  ArmarSeleccionarMaterias.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-05.
//

import SwiftUI

// MARK: - Paso para seleccionar las materias

/// View de la interfaz de selección de secciones de materias
struct ArmarSeleccionarMaterias: View {
    // MARK: Propiedades
    
    /// VIew Model que controla este View
    @ObservedObject var viewModel: SeleccionarMateriasViewModel
    
    /// ViewModel de los pasos del armado del horario
    @EnvironmentObject private var viewModelPasos: ArmarHorarioPasosViewModel
    
    // MARK: Constructor
    
    /// Constructor del View. Utiliza la carrera pasada para generar el view model
    /// - Parameters:
    ///   - carrera: La carrera que se desea usar para elegir las secciones
    init(carrera: CarreraSigla, selecciones: Set<InfoAsignatura>?) {
        // Generamos el view model
        self.viewModel = SeleccionarMateriasViewModel(paraCarrera: carrera)
        
        // Tratamos de recuperar las selecciones previas
        if selecciones != nil {
            self.viewModel.cargarSelecciones(selecciones!)
        }
    }
    
    // MARK: Body
    
    var body: some View {
        Form {
            Section(header: Text(viewModel.carrera.nombreLargo)) {
                ForEach(viewModel.materiasDisponibles, id: \.self) { materia in
                    let seleccionado = viewModel.materiasSeleccionadas.contains(materia)
                    
                    Button {
                        if seleccionado {
                            viewModel.quitarMateria(materia)
                        } else {
                            viewModel.agregarMateria(materia)
                        }
                    } label: {
                        // Vista
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(seleccionado ? .blue : .gray)
                            Text(materia.nombre)
                        }
                        .foregroundColor(Color(.label))
                    }
                }
            }
        }
        .navigationBarTitle("Seleccione materias", displayMode: .inline)
        .navigationBarItems(leading: botonAtras, trailing: botonSiguiente)
    }
    
    /// View del botón que pasa a la anterior selección de materias
    var botonAtras: some View {
        Button("Atrás") {
            viewModelPasos
                .mostrarAnteriorSeleccionMaterias(materiasSeleccionadas: viewModel.materiasSeleccionadas)
        }
    }
    
    /// View del botón que pasa a la siguiente selección de materias
    var botonSiguiente: some View {
        Button("Siguiente") {
            viewModelPasos
                .mostrarSiguienteSeleccionMaterias(materiasSeleccionadas: viewModel.materiasSeleccionadas)
        }.disabled(viewModel.materiasSeleccionadas.isEmpty)
    }
    
}
