//
//  Seccion.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

/// Modelo que representa una sección de una materia.
/// Equivale a una fila del horario en el Excel
class Seccion: Object, Identifiable {
    // MARK: - Propiedades
    
    /// Identificador de la sección
    @objc dynamic var id = UUID().uuidString
    
    /// Asignatura de la sección
    @objc dynamic var asignatura: Asignatura?
    
    /// Carrera de la sección
    @objc dynamic var carrera: Carrera?
    
    /// Docente de la sección
    @objc dynamic var docente: String = ""
    
    /// Código de la sección
    @objc dynamic var codigo: String = ""
    
    /// Si la sección fue elegida por el usuario
    @objc dynamic var elegido: Bool = false
    
    /// Horarios a la cuales esta sección pertenece. En teoría solo deberia de haber uno.
    let horariosCarrera = LinkingObjects(fromType: HorarioCarrera.self, property: "secciones")
    
    /// Examenes que posee esta sección
    let examenes = List<Examen>()
    
    /// Clases que posee esta sección
    let clases = List<Clase>()
    
    /// Turno de esta sección
    var turno: TurnoSeccion {
        .obtenerTurno(para: codigo)
    }

    // MARK: - Métodos
    
    /// Función auxiliar que permite a `Realm` identificar las secciones por su id en la base de datos.
    override static func primaryKey() -> String? {
        return "id"
    }
}
