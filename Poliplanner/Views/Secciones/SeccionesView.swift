//
//  SeccionesView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-08.
//

import SwiftUI

struct SeccionesView: View {
    @ObservedObject private var viewModel = SeccionesViewModel()
    
    var body: some View {
        Form {
            ForEach(viewModel.seccionesActivas) { seccion in
                SeccionCeldaView(seccion: seccion)
            }
        }
        .navigationBarTitle(Text("Secciones"))
    }
}

struct SeccionCeldaView: View {
    let seccion: Seccion
    
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

#if DEBUG
struct SeccionesView_Previews: PreviewProvider {
    static let seccion: Seccion = {
        let seccion = Seccion()
        seccion.asignatura = Asignatura()
        seccion.asignatura?.nombre = "Investigación de Operaciones I"
        seccion.codigo = "TQ"
        seccion.docente = "Ms. Zunilda Rossana Fernandéz Espínola"
        return seccion
    }()
    
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
