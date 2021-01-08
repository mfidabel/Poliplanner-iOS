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
    
    /// Indica si la interfaz se esta mostrando o no
    @Binding var estaPresentado: Bool
    
    /// VIew Model que controla este View
    @ObservedObject var viewModel: SeleccionarMateriasViewModel
    
    // MARK: Constructor
    
    /// Constructor del View. Utiliza el horario de clases y la carrera pasada para generar el view model
    /// - Parameters:
    ///   - horarioClase: Horario de clases sobre la cual se cargaran las secciones
    ///   - carrera: La carrera que se desea usar para elegir las secciones
    ///   - estaPresentado: Una propiedad que indica si esta interfaz se estra mostrando o no
    init(horarioClase: HorarioClase, carrera: CarreraSigla, estaPresentado: Binding<Bool>) {
        self._estaPresentado = estaPresentado
        self.viewModel = SeleccionarMateriasViewModel(horarioClase: horarioClase, paraCarrera: carrera)
    }
    
    // MARK: Body
    
    var body: some View {
        List {
            // Por cada materia
            ForEach(viewModel.materias, id: \.key) { materia in
                Section(header: Text(materia.key)) {
                    // Por cada sección
                    ForEach(materia.value, id: \.id) { seccion in
                        let seleccionado = viewModel.seccionSeleccionada(seccion)
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(seleccionado ? .blue : .gray)
                            Text("\(seccion.codigo)")
                            Image(systemName: "arrow.right")
                            Text(seccion.docente)
                        }
                        .onTapGesture {
                            if seleccionado {
                                viewModel.quitarSeccion(seccion)
                            } else {
                                viewModel.agregarSeccion(seccion)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text("Seleccione las materias"))
        .navigationBarItems(trailing: botonConstruir)
    }
    
    /// View del Botón que hará que se cargue el horario de clases a la base de datos
    var botonConstruir: some View {
        Button("Terminar") {
            self.viewModel.cargarSecciones()
            self.estaPresentado = false
        }
    }
    
}
