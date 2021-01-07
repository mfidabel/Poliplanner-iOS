//
//  TurnoSeccion.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-27.
//

import Foundation

/// Describe un turno de una sección
enum TurnoSeccion: String {
    // MARK: - Turnos
    
    /// Turno Mañana
    case mañana = "M"
    
    /// Turno Tarde
    case tarde = "T"
    
    /// Turno Noche
    case noche = "N"
    
    /// Turno desconocido
    case sinTurno = "ST"
    
    // MARK: - Métodos
    
    /// Genera un `TurnoSeccion` para cierto código de sección
    /// - Parameter codigoSeccion: Cadena que contiene el código de donde vamos a obtener el turno
    /// - Returns: El turno al que pertenece el código, si no pertenece a ninguno retorna `TurnoSeccion.sinTurno`
    static func obtenerTurno(para codigoSeccion: String) -> TurnoSeccion {
        if NSRegularExpression.turno.matches(codigoSeccion) {
            return TurnoSeccion(rawValue: "\(codigoSeccion.first!)") ?? .sinTurno
        } else {
            return .sinTurno
        }
    }
    
    // MARK: - Propiedades
    
    /// Nombre del turno
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
    
    /// Nombre largo del turno
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
