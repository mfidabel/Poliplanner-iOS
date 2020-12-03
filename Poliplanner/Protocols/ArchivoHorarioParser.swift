//
//  ArchivoHorarioParser.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//

import Foundation

protocol ArchivoHorarioParser {
    /// Inicializa el parseador con un archivo representado por su URL
    /// - Parameter url: URL del archivo
    init(archivoURL url: URL)
    
    /// Genera el horario solamente de las carreras solicitadas.
    /// - Parameter carreras: Debe ser un vector de CarreraSigla que contengan las carreras
    /// - Throws: Error de parseo del archivo
    /// - Returns: Horario de clases y examenes generado por el archivo
    func generarHorario(paraCarreras carreras: [CarreraSigla]) throws -> HorarioClase
}

extension ArchivoHorarioParser {
    /// Genera el horario de todas las carreras disponibles en el enumerador
    /// - Throws: Error de parseo del archivo
    /// - Returns: Horario de clases y examenes generado por el archivo
    func generarHorario() throws  -> HorarioClase {
        return try self.generarHorario(paraCarreras: CarreraSigla.carreras)
    }
}
