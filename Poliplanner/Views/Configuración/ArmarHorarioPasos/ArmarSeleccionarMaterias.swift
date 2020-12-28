//
//  ArmarSeleccionarMaterias.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-05.
//

import SwiftUI

struct ArmarSeleccionarMaterias: View {
    @Binding var estaPresentado: Bool
    @ObservedObject var viewModel: SeleccionarMateriasViewModel
    
    init(horarioClase: HorarioClase, carrera: CarreraSigla, estaPresentado: Binding<Bool>) {
        self._estaPresentado = estaPresentado
        self.viewModel = SeleccionarMateriasViewModel(horarioClase: horarioClase, paraCarrera: carrera)
    }
    
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
    
    var botonConstruir: some View {
        Button("Terminar") {
            self.viewModel.cargarSecciones()
            self.estaPresentado = false
        }
    }
    
}
