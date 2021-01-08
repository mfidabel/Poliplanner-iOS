//
//  SeccionesView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-08.
//

import SwiftUI

// MARK: - Secciones

/// View principal que muestra las secciones de las materias que el usuario ha elegido
struct SeccionesView: View {
    // MARK: Propiedades
    
    /// View Model que controla este `View`
    @ObservedObject private var viewModel = SeccionesViewModel()
    
    // MARK: Body
    
    var body: some View {
        Form {
            ForEach(viewModel.seccionesActivas) { seccion in
                SeccionCeldaView(seccion: seccion)
            }
        }
        .navigationBarTitle(Text("Secciones"))
    }
}

// MARK: - Celda de Sección

/// Celda de una sección que se mostrará dentro de la lista de secciones
struct SeccionCeldaView: View {
    // MARK: Propiedades
    
    /// Sección que representa esta view
    let seccion: Seccion
    
    // MARK: Body
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                Text(seccion.asignatura!.nombre)
                    .font(.title3)
                HStack {
                    Text(seccion.docente)
                        .font(.footnote)
                    Spacer()
                    Text(seccion.codigo)
                        .fontWeight(.bold)
                        .frame(width: 50.0, alignment: .trailing)
                    
                }
                .padding(.top, 1)
            }
            .padding()
        }
    }
}

// MARK: - Preview
#if DEBUG
/// :nodoc:
struct SeccionCeldaView_Previews: PreviewProvider {
    static var seccion: Seccion {
        let seccion = Seccion()
        seccion.asignatura = Asignatura()
        seccion.asignatura?.nombre = "Investigación de Operaciones I"
        seccion.codigo = "TQ"
        seccion.docente = "Ms. Zunilda Rossana Fernandéz Espínola"
        return seccion
    }
    
    static var previews: some View {
        Group {
            Form {
                SeccionCeldaView(seccion: seccion)
            }
            
            Form {
                SeccionCeldaView(seccion: seccion)
            }
            .environment(\.colorScheme, .dark)
        }
        .previewLayout(.fixed(width: 400, height: 200))
    }
}
#endif
