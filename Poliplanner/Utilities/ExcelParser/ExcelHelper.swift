//
//  ExcelHelper.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-04.
//

import Foundation
import Regex

/// Conjunto de utilidades para parsear los horarios de clases
final class ExcelHelper {
    // MARK: Constantes
    
    /// Regex que indica un rango de horas en una cadena aplanada.
    /// Además guarda el siguiente caracter para verificar si es laboratorio
    /// Ejemplos: "18:00-19:00", "21:00-22:30".
    static let regexHoraClase = Regex(
        "([0-1][0-9]|2[0-3]):([0-5][0-9])-([0-1][0-9]|2[0-3]):([0-5][0-9])(?=(.?))",
        groupNames: ["horaInicio", "minutoInicio", "horaFin", "minutoFin", "verificador"])
    
    /// Regex que representa una fecha de examen en una cadena aplanada
    /// Ejemplos: "08/09/21", "13/04/2021"
    static let regexFecha = Regex(
        "(0?[1-9]|[12][0-9]|3[01])[-/](0?[1-9]|1[012])[-/]([0-9]{4}|[0-9]{2})",
        groupNames: ["dia", "mes", "año"]
    )
    
    /// Regex que representa una hora de examen en una cadena aplanada
    /// Ejemplos: "08:00", "21:30"
    static let regexHora = Regex("([0-1][0-9]|2[0-3]|[1-9]):([0-5][0-9])",
                                 groupNames: ["hora", "minuto"]
    )
    
    // MARK: Métodos
    
    /// Dado una cadena con una posible fecha, trata de parsear y convertirlo en componentes de fecha
    /// - Parameter valor: Cadena que contiene la fecha sin parsear
    /// - Returns: Componentes de la fecha.
    static func obtenerFechaComponentes(para valor: String) -> DateComponents? {
        guard let fechaMatch = regexFecha.findFirst(in: valor) else {
            return nil
        }
        
        var fechaComponentes: DateComponents = .componentesReferencia
        
        var anho = Int(fechaMatch.group(named: "año")!)
        anho = anho != nil && anho! < 2000 ? anho! + 2000 : anho
        
        // Agarramos la fecha sin la hora
        fechaComponentes.day = Int(fechaMatch.group(named: "dia")!)
        fechaComponentes.month = Int(fechaMatch.group(named: "mes")!)
        fechaComponentes.year = anho
        
        return fechaComponentes
    }
    
    /// Dada una cadena con una posible hora, trata de paresear y convertirlo en una hora
    /// - Parameter valor: Cadena que contiene la hora sin parsear
    /// - Returns: La hora y el minuto que se obtuvo
    static func obtenerHora(para valor: String) -> (hora: Int, minuto: Int)? {
        let valorLimpio = valor.replacingOccurrences(of: " ", with: "")
        
        if let match = regexHora.findFirst(in: valorLimpio) {
            // Tiene formato HH:mm
            guard let hora = Int(match.group(named: "hora")!),
                  let minuto = Int(match.group(named: "minuto")!) else {
                return nil
            }
            
            return (hora: hora, minuto: minuto)
        } else if let horaFloat = Float(valorLimpio), horaFloat < 1.0, horaFloat >= 0.0 {
            // Tiene formato OLE
            let tiempoFloat = horaFloat * 24.0
            let hora = Int(tiempoFloat)
            let minuto = Int( (tiempoFloat - Float(hora) ) * 60 )
            
            return (hora: hora, minuto: minuto)
        } else {
            return nil
        }
    }
    
    /// Dado el valor de la clase, su aula y el día.
    /// Genera un vector con todas las clases encontradas
    /// - Parameters:
    ///   - valor: Valor encontrado en la cabecera del día en la sección
    ///   - dia: Día de la semana a la que corresponde la clase
    ///   - aula: Valor del aula encontrado en la cabecera de aula del respectivo día
    /// - Returns: Todas las clases encontradas para el valor dado.
    static func obtenerClases(para valor: String, elDia dia: DiaClase, enAula aula: String? = "") -> [Clase] {
        var clases: [Clase] = []
        let aulas = (aula ?? "").split(separator: "\n")
        
        // Aplanamos la cadena
        let valorLimpio = valor
            .lowercased() // Pasamos todo a minúsculas
            .replacingOccurrences(of: " ", with: "") // Eliminamos los espacios
            .replacingOccurrences(of: "\n", with: "") // Eliminamos los saltos de línea
            .replacingOccurrences(of: ".", with: ":") // Horas que en vez de estar HH:mm estan HH.mm
            .replacingOccurrences(of: "grupo[a-z]", with: "", options: .regularExpression)
        
        let coincidencias = regexHoraClase.findAll(in: valorLimpio)
        
        for (index, match) in coincidencias.enumerated() {
            // Creamos el draft de la clase
            let claseDraft: Clase = Clase()
            
            // Día de clase
            claseDraft.diaEnum = dia
            
            // Horas
            claseDraft.horaInicio = "\(match.group(named: "horaInicio")!):\(match.group(named: "minutoInicio")!)"
            claseDraft.horaFin = "\(match.group(named: "horaFin")!):\(match.group(named: "minutoFin")!)"
            
            // Tratamos de hallar un aula
            let aulaCorrespondiente = aulas.count > index ? "\(aulas[index])" : nil
            
            // Verificamos que tipo es para asignar un aula correspondiente
            let verificador = match.group(named: "verificador")
            
            switch verificador {
            case .none,
                 .some("[0-9]".r):
                // Es una clase normal
                claseDraft.aula = aulaCorrespondiente ?? ""
            case .some("[(l)]".r):
                // Es un laboratorio
                claseDraft.aula = aulaCorrespondiente ?? "Lab"
            default:
                break
            }
            
            // Agregamos la clase a los resultados
            clases.append(claseDraft)
        }
        
        return clases
    }
    
}
