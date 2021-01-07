//
//  EstadoHorario.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-05.
//

import Foundation

/// Representa el estado de un horario de clases en la base de datos.
enum EstadoHorario: String {
    // MARK: - Estados
    
    /// Indica que el horario esta creado pero no se cargó a la base de datos
    /// ni se muestran sus secciones elegidas en la aplicación.
    case DRAFT
    
    /// Indica que el horario esta activo y por ende todas sus secciones elegidas
    /// deben mostrarse en la aplicación.
    case ACTIVO
    
    /// Indica que el horario esta en la base de datos pero sus secciones elegidas
    /// no se muestran en la aplicación
    case INACTIVO
}
