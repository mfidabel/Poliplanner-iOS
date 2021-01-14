//
//  InformacionHorarioView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-12.
//

import SwiftUI

// MARK: - View que muestra la información sobre un horario

/// View principal que muestra la información de un horario de clases cargado
struct InformacionHorarioView: View {
    /// :nodoc:
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: Propiedades
    
    /// Horario de clases que se esta mostrando
    let horarioClase: HorarioClase
    
    /// Indica si el horario de clases esta activo o no
    @State var estaActivo: Bool
    
    /// Nombre del horario
    @State var nombreHorario: String
    
    /// Periodo académico del horario
    @State var periodoAcademico: String
    
    /// Fecha de actualización
    @State var fechaActualizacion: String
    
    // MARK: Constructor
    
    /// Constructor del view
    init(_ horarioClase: HorarioClase) {
        self.horarioClase = horarioClase
        self._estaActivo = State(initialValue: horarioClase.activo)
        self._nombreHorario = State(initialValue: horarioClase.nombre)
        self._periodoAcademico = State(initialValue: horarioClase.periodoAcademico)
        self._fechaActualizacion = State(initialValue: horarioClase.fechaActualizacion)
    }
    
    // MARK: Body
    
    var body: some View {
        Form {
            Section(header: Text("Nombre")) {
                TextField("Nombre del horario", text: $nombreHorario, onCommit: {
                    PoliplannerStore.shared.cambiarNombreHorario(horarioClase, a: nombreHorario)
                })
            }
            
            Section(header: Text("Periodo Académico")) {
                TextField("Periodo Académico", text: $periodoAcademico, onCommit: {
                    PoliplannerStore.shared.cambiarPeriodoHorario(horarioClase, a: periodoAcademico)
                })
            }
            
            Section(header: Text("Fecha de actualización")) {
                TextField("Fecha", text: $fechaActualizacion, onCommit: {
                    PoliplannerStore.shared.cambiarFechaActualizacionHorario(horarioClase, a: fechaActualizacion)
                })
            }
            
            Section(header: Text("Acciones")) {
                // Botón para activar desactivar el horario
                Toggle("Mostrar horario de clases", isOn: $estaActivo)
                    // Cambia el estado del horario de clase
                    .onChange(of: estaActivo, perform: { newValue in
                        PoliplannerStore.shared
                            .alternarEstadoHorario(horarioClase, estado: EstadoHorario(newValue))
                    })
                
                // Botón para eliminar el horario
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                    PoliplannerStore.shared.eliminarHorario(horarioClase)
                }
                label: {
                    Text("Eliminar horario de clases")
                }.accentColor(.red)
                
            }
        }
        .navigationTitle("Información de horario")
    }
}

// MARK: - Preview

#if DEBUG
/// :nodoc:
struct InformacionHorarioView_Previews: PreviewProvider {
    static var horarioClase: HorarioClase {
        let horario = HorarioClase()
        horario.nombre = "Primer Periodo 04-02-2020"
        horario.periodoAcademico = "PRIMER PERIODO ACADÉMICO 2020"
        horario.fechaActualizacion = "29/01/2020"
        horario.estado = EstadoHorario.ACTIVO.rawValue
        return horario
    }
    
    static var previews: some View {
        TabView {
            NavigationView {
                InformacionHorarioView(horarioClase)
            }
        }
    }
}
#endif
