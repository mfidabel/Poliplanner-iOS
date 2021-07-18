//
//  ArmarConfirmarHorario.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import SwiftUI

struct ArmarConfirmarHorario: View {
    // MARK: Propiedades
    
    /// ViewModel de los pasos del armado del horario
    @EnvironmentObject private var viewModelPasos: ArmarHorarioPasosViewModel
    
    /// Horario de clases
    let horarioClases = PoliplannerStore.shared.horarioClaseDraft
    
    // MARK: Body
    
    var body: some View {
        Form {
            
            Section(header: Text("Nombre")) {
                Text(horarioClases.nombre)
            }
            
            Section(header: Text("Periodo Académico")) {
                Text(horarioClases.periodoAcademico)
            }
            
            Section(header: Text("Fecha de actualización")) {
                Text(horarioClases.fechaActualizacion)
            }
            
        }
        .navigationBarTitle("Confirmar horario", displayMode: .inline)
        .navigationBarItems(leading: botonAtras, trailing: botonSiguiente)
    }
    
    /// View del botón para volver atrás
    var botonAtras: some View {
        Button("Atrás") {
            viewModelPasos.retroceder()
        }
    }
    
    /// View del botón para finalizar
    var botonSiguiente: some View {
        Button("Confirmar") {
            viewModelPasos.avanzar()
        }
    }
}

// MARK: - Preview

#if DEBUG
/// :nodoc:
struct ArmarConfirmarHorario_Previews: PreviewProvider {    
    static var previews: some View {
        ArmarConfirmarHorario()
    }
}
#endif
