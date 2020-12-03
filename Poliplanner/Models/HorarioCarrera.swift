//
//  HorarioCarrera.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-27.
//

import Foundation
import RealmSwift

class HorarioCarrera: Object, Identifiable {
    // swiftlint:disable identifier_name
    @objc dynamic var id = UUID().uuidString
    // swiftlint:enable identifier_name
    @objc dynamic var horarioClase: HorarioClase?
    @objc dynamic var nombreCarrera: String = ""
    let secciones = LinkingObjects(fromType: Seccion.self, property: "horarioCarrera")
    
    public var carrera: CarreraSigla {
        CarreraSigla(rawValue: self.nombreCarrera) ?? .invalido
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
