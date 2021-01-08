//
//  DateComponents+Referencia.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation

extension DateComponents {
    // MARK: - Componentes
    
    /// Calendario de referencia de la aplicación
    static var componentesReferencia: DateComponents {
        var componente = DateComponents()
        componente.calendar = Calendar(identifier: .gregorian)
        componente.timeZone = TimeZone(identifier: "America/Asuncion") ?? .current
        return componente
    }
}

extension Date {
    // MARK: - Extra API
    
    /// Nombre del día localizado en es-PY
    var diaNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "eeee"
        dateFormatter.locale = Locale(identifier: "es-PY")
        let nombre = dateFormatter.string(from: self)
        return nombre.prefix(1).capitalized + nombre.dropFirst()
    }
    
    /// Nombre del mes localizado en es-PY
    var mesNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = Locale(identifier: "es-PY")
        let nombre = dateFormatter.string(from: self)
        return nombre.prefix(1).capitalized + nombre.dropFirst()
    }
    
    /// Nombre del año localizado en es-PY
    var añoNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    /// Nombre de la hora localizado en es-PY
    var horaNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    /// Numero de dia de la fecha localizado en es-PY
    var diaNumeroNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    /// Calendario base
    var base: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}

extension Calendar {
    // MARK: - Calendarios
    
    /// Calendario de referencia
    static var calendarioReferencia: Calendar {
        var calendario = Calendar(identifier: .gregorian)
        calendario.locale = Locale(identifier: "es-PY")
        return calendario
    }
}
