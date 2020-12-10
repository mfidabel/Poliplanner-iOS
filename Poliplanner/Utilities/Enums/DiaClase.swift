//
//  DiaClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-04.
//

import Foundation

enum DiaClase: String, Comparable, CaseIterable {
    case LUNES = "Lunes"
    case MARTES = "Martes"
    case MIERCOLES = "Miércoles"
    case JUEVES = "Jueves"
    case VIERNES = "Viernes"
    case SABADO = "Sábado"
    
    static func < (lhs: DiaClase, rhs: DiaClase) -> Bool {
        return lhs.numero < rhs.numero
    }
    
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
    
}
