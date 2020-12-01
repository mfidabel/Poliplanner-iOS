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
    @objc dynamic var horarioCarrera: HorarioCarrera?
    let examenes = LinkingObjects(fromType: Examen.self, property: "seccion")
    let clases = LinkingObjects(fromType: Clase.self, property: "seccion")

    override static func primaryKey() -> String? {
        return "id"
    }
}
