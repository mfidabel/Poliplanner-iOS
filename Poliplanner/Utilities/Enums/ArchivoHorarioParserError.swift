//
//  ArchivoHorarioParserError.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//
/// Errores posibles de un parseador de archivos de horarios de clases.
enum ArchivoHorarioParserError: Error {
    // MARK: - Errores
    
    /// No se pudo acceder al archivo que se desea parsear
    case archivoInaccesible
    
    /// El archivo que se pasó no se puede parsear o no es un archivo de horarios de clases.
    case archivoInvalido
    
    /// No se puede parsear los encabezados de una sección del archivo
    case encabezadoInvalido(descripcion: String)
}
