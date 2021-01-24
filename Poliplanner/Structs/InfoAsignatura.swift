//
//  InfoAsignatura.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import Foundation

/// Estructura que representa la entrada de una asignatura
struct InfoAsignatura: Hashable, Equatable {
    /// Departamento de la asignatura
    var departamento: String
    
    /// Nombre de la asignatura
    var nombre: String
    
    /// Nivel de la asignatura
    var nivel: String
    
    /// Semestre/Grupo de la asignatura
    var semGrupo: String
}
