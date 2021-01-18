//
//  ListaEventosView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-17.
//

import SwiftUI

// MARK: - Lista de Eventos

/// View de una lista de eventos ordenados y agrupados por la fecha del evento
struct ListaEventosView: View {
    // MARK: Propiedades
    
    /// Eventos agrupados por la fecha
    let eventosAgrupados: [ (key: Date, value: [InfoEventoCalendario]) ]
    
    // MARK: Constructor
    
    /// Constructor que toma los eventos pasados como argumentos, los agrupa y los ordena según la fecha
    /// del evento.
    /// - Parameter eventos: Eventos que se desean mostrar en la lista
    init(eventos: [InfoEventoCalendario]) {
        eventosAgrupados = Self.agruparEventos(eventos)
    }
    
    // MARK: Body
    
    var body: some View {
        if eventosAgrupados.isEmpty {
            // Caso no haya ningún evento en el mes
            Text("No tienes eventos este mes")
        } else {
            // Caso si haya eventos
            ScrollView {
                Spacer()
                    .frame(height: 10.0)
                VStack {
                    // Por cada día
                    ForEach(eventosAgrupados, id: \.key) { grupoEvento in
                        let eventos = grupoEvento.value
                        Section(header: HeaderEventoView(fecha: grupoEvento.key)) {
                            VStack {
                                // Por cada evento del día
                                ForEach(eventos, id: \.self) { evento in
                                    EventoView(evento: evento)
                                        .padding(.vertical, 10)
                                }
                            }
                        }.padding(.horizontal, 10)
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: Métodos
    
    /// Agrupa los eventos y los ordena según la fecha
    /// - Parameter eventos: Eventos que deseamos agrupar y ordenar
    /// - Returns: Un Vector de eventos agrupados por su fecha
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

// MARK: - Preview
#if DEBUG
/// :nodoc:
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
#endif
