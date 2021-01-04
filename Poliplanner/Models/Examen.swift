//
//  Examen.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Examen: Object, Identifiable, Calendarizable {
    // swiftlint:disable identifier_name
    @objc dynamic var id = UUID().uuidString
    // swiftlint:enable identifier_name
    @objc dynamic var tipo: String = TipoExamen.evaluacion.rawValue
    @objc dynamic var fecha: Date = Date()
    @objc dynamic var aula: String = ""
    @objc dynamic var revision: Revision?
    let secciones = LinkingObjects(fromType: Seccion.self, property: "examenes")
    
    var seccion: Seccion {
        secciones.first!
    }
    
    // Puente entre enumerador de tipo de examen a atributo
    var tipoEnum: TipoExamen {
        get {
            return TipoExamen(rawValue: tipo)!
        }
        set {
            tipo = newValue.rawValue
        }
    }

    // MARK: - Calendario
    var eventoCalendario: InfoEventoCalendario {
        InfoEventoCalendario(fecha: fecha,
                             titulo: tipoEnum.nombreLindo(),
                             descripcion: seccion.asignatura!.nombre,
                             aula: aula)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
