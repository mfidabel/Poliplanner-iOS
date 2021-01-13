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
    // MARK: Propiedades
    
    /// Horario de clases que se esta mostrando
    let horarioClase: HorarioClase
    
    /// :nodoc:
    @Environment(\.presentationMode) var presentationMode
    
    /// Indica si el horario de clases esta activo o no
    @State var estaActivo: Bool
    
    // MARK: Constructor
    
    /// Constructor del view
    init(_ horarioClase: HorarioClase) {
        self.horarioClase = horarioClase
        self._estaActivo = State(initialValue: horarioClase.activo)
    }
    
    // MARK: Body
    
    var body: some View {
        Form {
            Section(header: Text("Nombre")) {
                Text(horarioClase.nombre)
            }
            
            Section(header: Text("Periodo Academico")) {
                Text(horarioClase.periodoAcademico)
            }
            
            Section(header: Text("Fecha de actualización")) {
                Text(horarioClase.fechaActualizacion)
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
