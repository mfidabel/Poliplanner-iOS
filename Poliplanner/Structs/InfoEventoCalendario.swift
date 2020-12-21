//
//  InfoEventoCalendario.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation

/// Estructura que representa una entrada en el calendario
struct InfoEventoCalendario: Hashable {
    var fecha: Date
    var titulo: String
    var descripcion: String
    var aula: String = ""
}

// MARK: - API
extension InfoEventoCalendario {
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
