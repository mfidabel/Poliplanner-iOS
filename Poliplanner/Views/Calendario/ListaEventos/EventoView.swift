//
//  EventoView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-17.
//

import SwiftUI
// MARK: - Evento

/// View de un evento que estará dentro de la lista de eventos
struct EventoView: View {
    // MARK: Propiedades
    
    /// Evento que se esta mostrando
    let evento: InfoEventoCalendario
    
    // MARK: Body
    
    var body: some View {
        HStack(alignment: .top) {
            Text(evento.hora)
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
    
    // MARK: Constantes de estilo
    
    /// Fuente de la hora
    let fuenteHora: Font = .system(size: 19.0, weight: .light, design: .default)
    
    /// Fuente del título
    let fuenteTitulo: Font = .system(size: 18.0, weight: .medium, design: .default)
    
    /// Fuente de la descripción
    let fuenteDescripcion: Font = .system(size: 15.0, weight: .regular, design: .default)
    
    /// Fuente del aula
    let fuenteAula: Font = .system(size: 17.0, weight: .regular, design: .default)
}

// MARK: - Preview
#if DEBUG
/// :nodoc:
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
#endif
