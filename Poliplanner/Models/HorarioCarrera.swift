//
//  HorarioCarrera.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-27.
//

import Foundation
import RealmSwift

/// Modelo que representa el horario de una carrera.
/// Equivale a una página en el Excel
class HorarioCarrera: Object, Identifiable, CascadingDeletable {
    // MARK: Propiedades
    
    /// Identificador del Horario de Carrera
    @objc dynamic var id = UUID().uuidString
    
    /// Nombre de la carrera.
    /// Tratar de utilizar `HorarioCarrera.carrera` en vez de esta propiedad
    @objc dynamic var nombreCarrera: String = ""
    
    /// Secciones de la carrera
    let secciones: List<Seccion> = List<Seccion>()
    
    /// Horarios de clase en el que este horario pertenece. En teoría deberia de haber solo uno
    let horarioClase = LinkingObjects(fromType: HorarioClase.self, property: "horariosCarrera")
    
    /// Puente entre `HorarioCarrera.nombreCarrera` y el enumerador `CarreraSigla`
    public var carrera: CarreraSigla {
        CarreraSigla(rawValue: self.nombreCarrera) ?? .invalido
    }
    
    // MARK: Protocolo CascadingDeletable
    
    /// Propiedades que se eliminarán si se elimina este objeto
    static var propertiesToCascadeDelete: [String] = ["secciones"]
    
    // MARK: Métodos
    
    /// Función auxiliar que permite a `Realm` identificar los horarios de carrera por su id en la base de datos.
    override static func primaryKey() -> String? {
        return "id"
    }
}
