//
//  EventoView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-17.
//

import SwiftUI

struct EventoView: View {
    let evento: InfoEventoCalendario
    
    var body: some View {
        HStack(alignment: .top) {
            Text(evento.fecha.horaNombre)
                .font(fuenteHora)
            VStack(alignment: .leading) {
                HStack {
                    Text(evento.titulo)
                        .font(fuenteTitulo)
                    Spacer()
                    Text(evento.aula)
                        .font(fuenteAula)
                }
                Spacer()
                    .frame(height: 6.0)
                Text(evento.descripcion)
                    .font(fuenteDescripcion)
            }
        }
    }
    
    let fuenteHora: Font = .system(size: 19.0, weight: .light, design: .default)
    let fuenteTitulo: Font = .system(size: 18.0, weight: .medium, design: .default)
    let fuenteDescripcion: Font = .system(size: 15.0, weight: .regular, design: .default)
    let fuenteAula: Font = .system(size: 17.0, weight: .regular, design: .default)
}

struct EventoView_Previews: PreviewProvider {
    static let evento =
        InfoEventoCalendario(fecha: Date(), titulo: "1er. Examen Parcial",
                             descripcion: "Investigación de Operaciones I", aula: "A. Magna")
    
    static var previews: some View {
        EventoView(evento: evento)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
