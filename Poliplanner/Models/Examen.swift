//
//  Examen.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

/// Modelo que representa un examen de alguna sección
class Examen: Object, Identifiable, Calendarizable, CascadingDeletable {
    // MARK: Propiedades
    
    /// Identificador del examen
    @objc dynamic var id = UUID().uuidString
    
    /// Tipo de examen en String.
    /// Tratar de no editar directamente y utlizar en su sustitución `Examen.tipoEnum`
    @objc dynamic var tipo: String = TipoExamen.evaluacion.rawValue
    
    /// Fecha del examen
    @objc dynamic var fecha: Date = Date()
    
    /// Aula del examen
    @objc dynamic var aula: String = ""
    
    /// Revisión del examen
    @objc dynamic var revision: Revision?
    
    /// Secciones al que este examen pertenece.
    /// En teoría solo debe haber uno pero se deja la posibilidad de unir examenes que
    /// coinciden de distintas secciones de la misma materia
    let secciones = LinkingObjects(fromType: Seccion.self, property: "examenes")
    
    /// Sección a la cual pertenece este examen
    var seccion: Seccion {
        secciones.first!
    }
    
    /// Puente entre enumerador de tipo de examen a atributo `Examen.tipo`.
    var tipoEnum: TipoExamen {
        get {
            return TipoExamen(rawValue: tipo)!
        }
        set {
            tipo = newValue.rawValue
        }
    }

    // MARK: Protocolo Calendarizable
    
    /// Evento que se mostrará en el calendario
    var eventoCalendario: InfoEventoCalendario {
        InfoEventoCalendario(fecha: fecha,
                             titulo: tipoEnum.nombreLindo(),
                             descripcion: seccion.asignatura!.nombre,
                             aula: aula)
    }
    
    // MARK: Protocolo CascadingDeletable
    
    /// Propiedades que se eliminarán si se elimina este objeto
    static var propertiesToCascadeDelete: [String] = ["revision"]
    
    // MARK: Métodos
    
    /// Función auxiliar que permite a `Realm` identificar los examenes por su id en la base de datos.
    override static func primaryKey() -> String? {
        return "id"
    }
}
