//
//  EncabezadoXLSX.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-04.
//

import Foundation

enum EncabezadoXLSX: String {
    case item = "Item"
    case departamento = "DPTO."
    case asignatura = "Asignatura"
    case nivel = "Nivel"
    case semGrupo = "Sem/Grupo"
    case siglaCarrera = "Sigla carrera"
    case enfasis = "Enfasis"
    case plan = "Plan"
    case turno = "Turno"
    case seccion = "Sección"
    case titulo = "Tít"
    case apellido = "Apellido"
    case nombre = "Nombre"
    case correoInstitucional = "Correo Institucional"
    case primeraParcial = "1er. Parcial"
    case segundaParcial = "2do. Parcial"
    case primeraFinal = "1er. Final"
    case segundaFinal = "2do. Final"
    case revision = "Revisión"
    case lunes = "Lunes"
    case martes = "Martes"
    case miercoles = "Miércoles"
    case jueves = "Jueves"
    case viernes = "Viernes"
    case sabado = "Sábado"
    case sabadoTurnoNoche = "Fechas de clases de sábados (Turno Noche)"
    case aula = "AULA"
    case hora = "Hora"
    case lunesAula
    case martesAula
    case miercolesAula
    case juevesAula
    case viernesAula
    case sabadoAula
    case primeraParcialHora
    case segundaParcialHora
    case primeraFinalHora
    case segundaFinalHora
    case primeraParcialAula
    case segundaParcialAula
    case primerFinalAula
    case segundoFinalAula
    case revisionPrimerFinal
    case revisionSegundoFinal
    case revisionPrimerFinalHora
    case revisionSegundoFinalHora
        
    static let diasClases: [EncabezadoXLSX] = [.lunes, .martes, .miercoles, .jueves, .viernes, .sabado]
    static let examenes: [EncabezadoXLSX] = [.primeraParcial, .segundaParcial, .primeraFinal, .segundaFinal]
    static let revisiones: [EncabezadoXLSX] = [.revisionPrimerFinal, .revisionSegundoFinal]
    
    func esDiaClase() -> Bool {
        return Self.diasClases.contains(self)
    }
    
    func esExamen() -> Bool {
        return Self.examenes.contains(self)
    }
    
    func esHora() -> Bool {
        switch self {
        case .primeraParcialHora,
             .segundaParcialHora,
             .primeraFinalHora,
             .segundaFinalHora:
            return true
        default:
            return false
        }
    }
    
    func examenHora() -> EncabezadoXLSX {
        switch self {
        case .primeraParcial:
            return .primeraParcialHora
        case .segundaParcial:
            return .segundaParcialHora
        case .primeraFinal:
            return .primeraFinalHora
        case .segundaFinal:
            return .segundaFinalHora
        default:
            return .hora
        }
    }
    
    func claseAula() -> EncabezadoXLSX {
        switch self {
        case .lunes:
            return .lunesAula
        case .martes:
            return .martesAula
        case .miercoles:
            return .miercolesAula
        case .jueves:
            return .juevesAula
        case .viernes:
            return .viernesAula
        case .sabado:
            return .sabadoAula
        default:
            return .aula
        }
    }
    
    func claseDia() -> DiaClase {
        switch self {
        case .lunes:
            return .LUNES
        case .martes:
            return .MARTES
        case .miercoles:
            return .MIERCOLES
        case .jueves:
            return .JUEVES
        case .viernes:
            return .VIERNES
        case .sabado:
            return .SABADO
        default:
            return .LUNES
        }
    }
    
    func examenTipo() -> TipoExamen {
        switch self {
        case .primeraParcial:
            return .primerParcial
        case .segundaParcial:
            return .segundoParcial
        case .primeraFinal:
            return .primerFinal
        case .segundaFinal:
            return .segundoFinal
        default:
            return .evaluacion
        }
    }
    
    func examenAula() -> EncabezadoXLSX {
        switch self {
        case .primeraParcial:
            return .primeraParcialAula
        case .segundaParcial:
            return .segundaParcialAula
        case .primeraFinal:
            return .primerFinalAula
        case .segundaFinal:
            return .segundoFinalAula
        default:
            return .aula
        }
    }
    
    func examenRevision() -> EncabezadoXLSX {
        switch self {
        case .primeraFinal:
            return .revisionPrimerFinal
        case .segundaFinal:
            return .revisionSegundoFinal
        default:
            return .revision
        }
    }
    
    func revisionHora() -> EncabezadoXLSX {
        switch self {
        case .revisionPrimerFinal:
            return .revisionPrimerFinalHora
        case .revisionSegundoFinal:
            return .revisionSegundoFinalHora
        default:
            return .revision
        }
    }
    
    func revisionExamen() -> EncabezadoXLSX {
        switch self {
        case .revisionPrimerFinal:
            return .primeraFinal
        case .revisionSegundoFinal:
            return .segundaFinal
        default:
            return .revision
        }
    }
}
