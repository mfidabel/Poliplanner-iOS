//
//  Revision.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

/// Modelo que representa la revisión de un `Examen`
class Revision: Object, Identifiable {
    // MARK: - Propiedades
    
    /// Identificador de la revisión
    @objc dynamic var id = UUID().uuidString
    
    /// Fecha de la revisión
    @objc dynamic var fecha: Date = Date()
    
    /// Aula de la revisión
    @objc dynamic var aula: String = ""
    
    /// Exámenes a la cual la revisión pertenence.
    /// En teoría solo debe haber uno pero se deja la posibilidad de unir revisiones que
    /// coinciden de distintas secciones de la misma materia
    let examenes = LinkingObjects(fromType: Examen.self, property: "revision")
    
    /// Examen a la cual la revisión pertenece
    var examen: Examen {
        examenes.first!
    }

    // MARK: - Métodos
    
    /// Función auxiliar que permite a `Realm` identificar las revisiones por su id en la base de datos.
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Revision: Calendarizable {
    // MARK: - Protocolo Calendarizable
    
    /// Evento que se mostrará en el calendario
    var eventoCalendario: InfoEventoCalendario {
        InfoEventoCalendario(fecha: fecha,
                             titulo: examen.tipoEnum.nombreRevision(),
                             descripcion: examen.seccion?.asignatura!.nombre ?? "",
                             aula: aula)
    }
}
