//
//  ArmarSeleccionarCarrera.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-04.
//

import SwiftUI

struct ArmarSeleccionarCarrera: View {
    @ObservedObject var PPStore: PoliplannerStore = PoliplannerStore.shared
    @Binding var estaPresentando: Bool
    
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
            
        }.navigationTitle("Seleccione su carrera")
        .navigationBarItems(leading: botonCancelar)
    }
    
    var botonCancelar: some View {
        Button("Cancelar") {
            estaPresentando = false
        }
    }
}

struct ArmarSeleccionarCarrera_Previews: PreviewProvider {
    static var previews: some View {
        ArmarSeleccionarCarrera(estaPresentando: .constant(true))
    }
}
