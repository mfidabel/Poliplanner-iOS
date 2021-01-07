//
//  TipoExamen.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-13.
//

import Foundation

/// Indica que tipo de examen es.
enum TipoExamen: String {
    // MARK: - Exámenes
    
    /// Representa un 1er. Parcial
    case primerParcial = "1er. Parcial"
    
    /// Representa un 2do. Parcial
    case segundoParcial = "2do. Parcial"
    
    /// Representa un 1er. Final
    case primerFinal = "1er. Final"
    
    /// Representa un 2do. Final
    case segundoFinal = "2do. Final"
    
    /// Representa una evaluación no predefinida
    case evaluacion = "Evaluación"
    
    // MARK: - Métodos
    
    /// Devuelve el nombre que es deseable mostrar al usuario
    /// - Returns: Cadena con el nombre
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
    
    /// Devuelve el nombre que es deseable mostrar al usuario si fuese una revisión
    /// - Returns: Cadena con el nombre
    func nombreRevision() -> String {
        switch self {
        case .evaluacion:
            return "Revisión"
        default:
            return "Revisión \(self.nombreLindo())"
        }
    }
}
