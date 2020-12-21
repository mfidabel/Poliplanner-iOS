//
//  ListaEventosView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-17.
//

import SwiftUI

struct ListaEventosView: View {
    let eventosAgrupados: [ (key: Date, value: [InfoEventoCalendario]) ]
    
    init(eventos: [InfoEventoCalendario]) {
        eventosAgrupados = Self.agruparEventos(eventos)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(eventosAgrupados, id: \.key) { grupoEvento in
                    let eventos = grupoEvento.value
                    Section(header: HeaderEventoView(fecha: grupoEvento.key)) {
                        VStack {
                            ForEach(eventos, id: \.self) { evento in
                                EventoView(evento: evento)
                                    .padding(.vertical, 10)
                            }
                        }
                    }.padding(.horizontal, 10)
                }
            }
        }
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private static func agruparEventos(_ eventos: [InfoEventoCalendario]) ->
        [(key: Date, value: [InfoEventoCalendario])] {
        // Agrupamos los eventos por su fecha seteado en 0
        return Array(
            Dictionary(grouping: eventos) { $0.fecha.base }
        )
        // Ordenamos por fecha ascendente
        .sorted { (lhs, rhs) in
            return lhs.key < rhs.key
        }
    }
}

struct ListaEventosView_Previews: PreviewProvider {
    static let eventos: [InfoEventoCalendario] = [
        InfoEventoCalendario(fecha: Date(), titulo: "1er. Examen Parcial",
                             descripcion: "Investigación de Operaciones I", aula: "A01"),
        InfoEventoCalendario(fecha: Date(), titulo: "2er. Examen Parcial",
                             descripcion: "Ingenieria de Software II")
    ]
    
    static var previews: some View {
        ListaEventosView(eventos: eventos)
            .previewLayout(.fixed(width: 400, height: 600))
    }
}
