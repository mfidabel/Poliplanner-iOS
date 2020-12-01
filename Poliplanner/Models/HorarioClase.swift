//
//  HorarioClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-27.
//

import Foundation
import RealmSwift

class HorarioClase: Object, Identifiable {
    // swiftlint:disable identifier_name
    @objc dynamic var id = UUID().uuidString
    // swiftlint:enable identifier_name
    @objc dynamic var nombre: String = ""
    @objc dynamic var fechaActualizacion: String = ""
    @objc dynamic var periodoAcademico: String = ""
    let horariosCarrera = LinkingObjects(fromType: HorarioCarrera.self, property: "horarioClase")

    override static func primaryKey() -> String? {
        return "id"
    }
}
