//
//  CarreraSigla.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//
/// Representa una carrera en forma de su sigla.
enum CarreraSigla: String, CaseIterable {
    // MARK: - Carreras
    
    /// Ingeniería Aeronáutica
    case IAE
    
    /// Ingeniería en Ciencias de los Materiales
    case ICM
    
    /// Ingeniería en Electrónica
    case IEK
    
    /// Ingeniería en Electricidad
    case IEL
    
    /// Ingeniería en Energía
    case IEN
    
    /// Ingeniería en Informática
    case IIN
    
    /// Ingeniería en Marketing
    case IMK
    
    /// Ingeniería en Sistemas de Producción
    case ISP
    
    /// Licenciatura en Ciencias Atmosféricas
    case LCA
    
    /// Licenciatura en Ciencias de la Información
    case LCI
    
    /// Licenciatura en Ciencias Informáticas
    case LCIk
    
    /// Licenciatura en Electricidad
    case LEL
    
    /// Licenciatura en Gestión de la Hospitalidad
    case LGH
    
    /// Técnico Superior en Electrónica (en proceso de cierre)
    case TSE
    
    /// Caso Invalido
    case invalido
    
    // MARK: - Propiedades
    
    /// Retorna todas las carreras en el enumerador
    static var carreras: [CarreraSigla] {
        // Se obtiene todos los casos
        var casos: [CarreraSigla] = CarreraSigla.allCases
        // Removemos los casos invalidos
        casos.removeAll { value in
            return value == .invalido
        }
        // Retornamos la carrera
        return casos
    }
    
    /// Nombre largo de la carrera. Ejemplo: "IIN" -> "Ingeniería en Informática"
    var nombreLargo: String {
        switch self {
        case .IAE:
            return "Ingeniería Aeronáutica"
        case .ICM:
            return "Ingeniería en Ciencias de los Materiales"
        case .IEK:
            return "Ingeniería en Electrónica"
        case .IEL:
            return "Ingeniería en Electricidad"
        case .IEN:
            return "Ingeniería en Energía"
        case .IIN:
            return "Ingeniería en Informática"
        case .IMK:
            return "Ingeniería en Marketing"
        case .ISP:
            return "Ingeniería en Sistemas de Producción"
        case .LCA:
            return "Licenciatura en Ciencias Atmosféricas"
        case .LCI:
            return "Licenciatura en Ciencias de la Información"
        case .LCIk:
            return "Licenciatura en Ciencias Informáticas"
        case .LEL:
            return "Licenciatura en Electricidad"
        case .LGH:
            return "Licenciatura en Gestión de la Hospitalidad"
        case .TSE:
            return "Técnico Superior en Electrónica (en proceso de cierre)"
        case .invalido:
            return "invalido"
        }
    }
    
    /// Nombre corto de la carrera. Ejemplo: "Ingeniería en Informática" -> "IIN"
    var sigla: String {
        return self.rawValue
    }
}
