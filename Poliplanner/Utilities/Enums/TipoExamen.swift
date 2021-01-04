//
//  TipoExamen.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-13.
//

import Foundation

enum TipoExamen: String {
    case primerParcial = "1er. Parcial"
    case segundoParcial = "2do. Parcial"
    case primerFinal = "1er. Final"
    case segundoFinal = "2do. Final"
    case evaluacion = "Evaluación"
    
    func nombreLindo() -> String {
        switch self {
        case .primerParcial:
            return "1er. Examen Parcial"
        case .segundoParcial:
            return "2do. Examen Parcial"
        case .primerFinal:
            return "1er. Examen Final"
        case .segundoFinal:
            return "2do. Examen Final"
        case .evaluacion:
            return "Evaluación"
        }
    }
    
    func nombreRevision() -> String {
        switch self {
        case .evaluacion:
            return "Revisión"
        default:
            return "Revisión \(self.nombreLindo())"
        }
    }
}
