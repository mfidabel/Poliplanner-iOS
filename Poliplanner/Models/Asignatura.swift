//
//  Asignatura.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Asignatura: Object, Identifiable {
    // swiftlint:disable identifier_name
    @objc dynamic var id = UUID().uuidString
    // swiftlint:enable identifier_name
    @objc dynamic var departamento: String = ""
    @objc dynamic var nombre: String = ""
    @objc dynamic var nivel: String = ""
    @objc dynamic var semGrupo: String = ""

    var esDEF: Bool {
        NSRegularExpression.DEF.matches(nombre)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
