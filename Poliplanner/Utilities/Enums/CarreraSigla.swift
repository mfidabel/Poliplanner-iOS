//
//  CarreraSigla.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//
enum CarreraSigla: String, CaseIterable {
    case IAE
    case ICM
    case IEK
    case IEL
    case IEN
    case IIN
    case IMK
    case ISP
    case LCA
    case LCI
    case LCIk
    case LEL
    case LGH
    case TSE
    case invalido
    
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
