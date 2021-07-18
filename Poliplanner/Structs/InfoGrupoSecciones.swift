//
//  InfoGrupoSecciones.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import Foundation

/// Estructura que representa un grupo de secciones para mostrar en la selección de secciones
struct InfoGrupoSecciones: Hashable, Identifiable {
    // MARK: Propiedades
    
    /// `CarreraSigla` que le corresponde a esta asignatura
    var carrera: CarreraSigla
    
    /// Secciones que contiene esta asignatura
    var secciones: [Seccion]
    
    /// Identificador generado
    var id: String { "\(infoAsignatura.nombre) - \(carrera.sigla)" }
    
    /// Información de la asignatura
    var infoAsignatura: InfoAsignatura {
        secciones.first!.asignatura!.infoAsignatura
    }
}
