//
//  Clase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Clase: Object, Identifiable {
    // swiftlint:disable identifier_name
    @objc dynamic var id = UUID().uuidString
    // swiftlint:enable identifier_name
    @objc dynamic var dia: String = ""
    @objc dynamic var horaInicio: String = ""
    @objc dynamic var horaFin: String = ""
    @objc dynamic var aula: String = ""
    @objc dynamic var seccion: Seccion?

    override static func primaryKey() -> String? {
        return "id"
    }
}
