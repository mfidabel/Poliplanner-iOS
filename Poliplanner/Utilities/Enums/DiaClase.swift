//
//  DiaClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-04.
//

import Foundation

/// Enumerador de días de la semana
enum DiaClase: String, Comparable, CaseIterable {
    // MARK: - Días
    
    /// Lunes
    case LUNES = "Lunes"
    
    /// Martes
    case MARTES = "Martes"
    
    /// Miércoles
    case MIERCOLES = "Miércoles"
    
    /// Jueves
    case JUEVES = "Jueves"
    
    /// Viernes
    case VIERNES = "Viernes"
    
    /// Sábado
    case SABADO = "Sábado"
    
    // MARK: - Propiedades
    
    /// Representación en número de día en la semana
    var numero: Int {
        switch self {
        case .LUNES:
            return 1
        case .MARTES:
            return 2
        case .MIERCOLES:
            return 3
        case .JUEVES:
            return 4
        case .VIERNES:
            return 5
        case .SABADO:
            return 6
        }
    }
    
    /// Representación localizada
    var nombre: String {
        switch self {
        case .LUNES:
            return "Lunes"
        case .MARTES:
            return "Martes"
        case .MIERCOLES:
            return "Miércoles"
        case .JUEVES:
            return "Jueves"
        case .VIERNES:
            return "Viernes"
        case .SABADO:
            return "Sábado"
        }
    }
    
    // MARK: - Protocolo Comparable
    
    /// Permite comparar dos `DiaClase`. Se define como menor el que tenga el menor número
    /// - Parameters:
    ///   - lhs: Lado izquierdo de la operación binaria <.
    ///   - rhs: Lado derecho de la operación binaria <.
    /// - Returns: Verdadero si el lado izquierdo es menor al derecho, Falso caso contrario
    static func < (lhs: DiaClase, rhs: DiaClase) -> Bool {
        return lhs.numero < rhs.numero
    }
}
