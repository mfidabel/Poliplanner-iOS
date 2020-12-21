//
//  HeaderEventoView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-19.
//

import SwiftUI

struct HeaderEventoView: View {
    let fecha: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(fecha.diaNombre) \(fecha.diaNumeroNombre)")
                .font(.title2)
            Rectangle()
                .frame(height: 1.0)
        }
    }
}

struct HeaderEventoView_Previews: PreviewProvider {
    static let fecha: Date = Date()
    static var previews: some View {
        HeaderEventoView(fecha: fecha)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
