//
//  Seccion.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Seccion: Object, Identifiable {
    // swiftlint:disable identifier_name
    @objc dynamic var id = UUID().uuidString
    // swiftlint:enable identifier_name
    @objc dynamic var asignatura: Asignatura?
    @objc dynamic var carrera: Carrera?
    @objc dynamic var docente: String = ""
    @objc dynamic var codigo: String = ""
    @objc dynamic var elegido: Bool = false
    let horariosCarrera = LinkingObjects(fromType: HorarioCarrera.self, property: "secciones")
    let examenes = List<Examen>()
    let clases = List<Clase>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
