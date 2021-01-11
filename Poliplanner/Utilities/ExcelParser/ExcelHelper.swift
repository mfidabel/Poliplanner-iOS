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
    
    // MARK: Métodos
    
    /// Dado una cadena con una posible fecha, trata de parsear y convertirlo en componentes de fecha
    /// - Parameter valor: Cadena que contiene la fecha sin parsear
    /// - Returns: Componentes de la fecha.
    static func obtenerFechaComponentes(para valor: String) -> DateComponents? {
        guard let indiceEspacio = valor.firstIndex(of: " ") else {
            return nil
        }
        // TODO: Agregar regex a la fecha
        // Convertir fecha a date
        let fechaString = String(valor[valor.index(after: indiceEspacio)..<valor.endIndex])
            .split(separator: "/")
        
        var fechaComponentes: DateComponents = .componentesReferencia
        
        // Agarramos la fecha sin la hora
        fechaComponentes.day = Int(fechaString[0])
        fechaComponentes.month = Int(fechaString[1])
        fechaComponentes.year = Int(fechaString[2]) != nil ? Int(fechaString[2])! + 2000 : nil
        
        return fechaComponentes
    }
    
    /// Dada una cadena con una posible hora, trata de paresear y convertirlo en una hora
    /// - Parameter valor: Cadena que contiene la hora sin parsear
    /// - Returns: La hora y el minuto que se obtuvo
    static func obtenerHora(para valor: String) -> (hora: Int, minuto: Int)? {
        if NSRegularExpression.horaComun.matches(valor) {
            // Tiene formato HH:mm
            let valores = valor.split(separator: ":")
            
            guard let hora = Int(valores.first!),
                  let minuto = Int(valores.last!) else {
                return nil
            }
            
            return (hora: hora, minuto: minuto)
        } else if let horaDouble = Double(valor), horaDouble < 1, horaDouble > 0 {
            // Tiene formato OLE
            let tiempoDouble = horaDouble * 24.0
            let hora = Int(tiempoDouble)
            let minuto = Int( (tiempoDouble - Double(hora) ) * 60 )
            
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
