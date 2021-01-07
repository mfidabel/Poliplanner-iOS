//
//  Carrera.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

/// Modelo que representa una carrera como información.
/// No describe una carrera en sí, sino la carrera asociada a una sección en el horario.
class Carrera: Object, Identifiable {
    // MARK: - Propiedades
    
    /// Identificador de la carrera
    @objc dynamic var id = UUID().uuidString
    
    /// Sigla de la carrera
    @objc dynamic var sigla: String = ""
    
    /// Enfasis de la carrera
    @objc dynamic var enfasis: String = ""
    
    /// Plan de la carrera
    @objc dynamic var plan: String = ""

    // MARK: - Métodos
    
    /// Función auxiliar que permite a `Realm` identificar las carreras por su id en la base de datos.
    override static func primaryKey() -> String? {
        return "id"
    }
}
