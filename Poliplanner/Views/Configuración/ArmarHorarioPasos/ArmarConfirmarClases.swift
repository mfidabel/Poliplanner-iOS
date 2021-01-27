//
//  ArmarConfirmarClases.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import SwiftUI

/// View del paso donde se confirman las clases de las secciones seleccionadas al armar el horario
struct ArmarConfirmarClases: View {
    // MARK: Propiedades
    
    /// ViewModel de los pasos del armado del horario
    @EnvironmentObject private var viewModelPasos: ArmarHorarioPasosViewModel
    
    /// ViewModel de esta view
    @ObservedObject var viewModel: ConfirmarClasesViewModel
    
    // MARK: Constructor
    
    init(secciones: [Seccion]) {
        self.viewModel = ConfirmarClasesViewModel(secciones: secciones)
    }
    
    // MARK: Body
    
    var body: some View {
        ZStack {
            // Color fondo
            R.color.backgroundClaseMenu.color
                .edgesIgnoringSafeArea(.top)
            
            // Páginas
            PaginacionMateriaView(paginas: viewModel.paginas)
        }
        .navigationBarTitle("Confirmar clases", displayMode: .inline)
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

// struct ArmarConfirmarClases_Previews: PreviewProvider {
//    static var previews: some View {
//        ArmarConfirmarClases()
//    }
// }
