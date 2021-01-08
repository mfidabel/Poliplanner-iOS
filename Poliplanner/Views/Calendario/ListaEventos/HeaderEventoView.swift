//
//  HeaderEventoView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-19.
//

import SwiftUI

// MARK: - Header de Eventos
/// View de un header que se utiliza en la listas de eventos para cada fecha
struct HeaderEventoView: View {
    // MARK: Propiedades
    
    /// Fecha que representa el header
    let fecha: Date
    
    // MARK: Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(fecha.diaNombre) \(fecha.diaNumeroNombre)")
                .font(.title2)
            Rectangle()
                .frame(height: 1.0)
        }
    }
}

// MARK: - Preview
#if DEBUG
/// :nodoc:
struct HeaderEventoView_Previews: PreviewProvider {
    static let fecha: Date = Date()
    static var previews: some View {
        HeaderEventoView(fecha: fecha)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif
