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
    
    /// Store de Poliplanner, es utilizado para obtener el borrador del horario de clases
    @ObservedObject var PPStore: PoliplannerStore = PoliplannerStore.shared
    
    /// Indica si esta interfaz se está mostrando o no
    @Binding var estaPresentando: Bool
    
    // MARK: Body
    
    var body: some View {
        Group {
            Form {
                ForEach(PPStore.horarioClaseDraft.horariosCarrera) { horarioCarrera in
                    let destino = ArmarSeleccionarMaterias(horarioClase: PPStore.horarioClaseDraft,
                                                           carrera: horarioCarrera.carrera,
                                                           estaPresentado: $estaPresentando)
                    NavigationLink(destination: destino) {
                        Text("\(horarioCarrera.carrera.sigla) - \(horarioCarrera.carrera.nombreLargo)")
                    }
                }
            }
            Spacer()
            
        }.navigationTitle(Text("Seleccione su carrera"))
        .navigationBarItems(leading: botonCancelar)
    }
    
    /// View de un botón para cancelar la selección
    var botonCancelar: some View {
        Button("Cancelar") {
            estaPresentando = false
        }
    }
}

// MARK: - Preview
#if DEBUG
/// :nodoc:
struct ArmarSeleccionarCarrera_Previews: PreviewProvider {
    static var previews: some View {
        ArmarSeleccionarCarrera(estaPresentando: .constant(true))
    }
}
#endif
