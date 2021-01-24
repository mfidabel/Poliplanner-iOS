//
//  ArmarConfirmarExamenes.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import SwiftUI

struct ArmarConfirmarExamenes: View {
    // MARK: Propiedades
    
    /// ViewModel de los pasos del armado del horario
    @EnvironmentObject private var viewModelPasos: ArmarHorarioPasosViewModel
    
    // MARK: Body
    
    var body: some View {
        Text("Hello, World!")
            .navigationBarTitle("Confirmar exámenes", displayMode: .inline)
            .navigationBarItems(leading: botonAtras, trailing: botonSiguiente)
    }
    
    /// View del botón para volver atrás
    var botonAtras: some View {
        Button("Atrás") {
            viewModelPasos.retroceder()
        }
    }
    
    /// View del botón para ir al siguiente paso
    var botonSiguiente: some View {
        Button("Siguiente") {
            viewModelPasos.avanzar()
        }
    }
}

struct ArmarConfirmarExamenes_Previews: PreviewProvider {
    static var previews: some View {
        ArmarConfirmarExamenes()
    }
}
