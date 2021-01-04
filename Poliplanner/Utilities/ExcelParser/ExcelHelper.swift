//
//  ExcelHelper.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-04.
//

import Foundation

final class ExcelHelper {
    
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
}
