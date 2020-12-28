//
//  TurnoSeccion.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-27.
//

import Foundation

enum TurnoSeccion: String {
    case mañana = "M"
    case tarde = "T"
    case noche = "N"
    case sinTurno = "ST"
    
    static func obtenerTurno(para codigoSeccion: String) -> TurnoSeccion {
        if NSRegularExpression.turno.matches(codigoSeccion) {
            return TurnoSeccion(rawValue: "\(codigoSeccion.first!)") ?? .sinTurno
        } else {
            return .sinTurno
        }
    }
    
    var nombre: String {
        switch self {
        case .mañana:
            return "Mañana"
        case .tarde:
            return "Tarde"
        case .noche:
            return "Noche"
        case .sinTurno:
            return "Sin Turno"
        }
    }
    
    var nombreLargo: String {
        switch self {
        case .mañana:
            return "Turno Mañana"
        case .tarde:
            return "Turno Tarde"
        case .noche:
            return "Turno Noche"
        case .sinTurno:
            return "Sin Turno"
        }
    }
}
