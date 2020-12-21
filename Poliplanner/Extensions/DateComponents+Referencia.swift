//
//  DateComponents+Referencia.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation

extension DateComponents {
    static var componentesReferencia: DateComponents = {
        var componente = DateComponents()
        componente.calendar = Calendar(identifier: .gregorian)
        componente.timeZone = TimeZone(identifier: "America/Asuncion") ?? .current
        return componente
    }()
}

extension Date {
    var diaNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "eeee"
        dateFormatter.locale = Locale(identifier: "es-PY")
        let nombre = dateFormatter.string(from: self)
        return nombre.prefix(1).capitalized + nombre.dropFirst()
    }
    
    var mesNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        dateFormatter.locale = Locale(identifier: "es-PY")
        let nombre = dateFormatter.string(from: self)
        return nombre.prefix(1).capitalized + nombre.dropFirst()
    }
    
    var añoNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    var horaNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    var diaNumeroNombre: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var base: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}
