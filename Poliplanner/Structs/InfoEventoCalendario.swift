//
//  InfoEventoCalendario.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation

/// Estructura que representa una entrada en el calendario de la sección Calendario
struct InfoEventoCalendario: Hashable {
    // MARK: - Propiedades
    
    /// Fecha del evento
    var fecha: Date
    
    /// Título a mostrar del evento
    var titulo: String
    
    /// Descripción a mostrar del evento
    var descripcion: String
    
    /// En que aula se desarrollará el evento
    var aula: String = ""
}

extension InfoEventoCalendario {
    // MARK: - API
    
    /// Verifica si este evento se da en la fecha actual
    /// - Returns: Verdadero si es que coincide con la fecha actual, falso caso contrario
    var esHoy: Bool {
        Calendar.current.isDate(fecha, inSameDayAs: Date())
    }
    
    /// Verifica si este evento coincide con la fecha pasada como argumento
    /// - Parameter conFecha: Fecha contra la cual se quiere saber si coincide
    /// - Returns: Verdadero si es que coincide con la fecha pasada como argumento, falso caso contrario
    func coincideCon(fecha conFecha: Date) -> Bool {
        Calendar.current.isDate(conFecha, inSameDayAs: self.fecha)
    }
}
