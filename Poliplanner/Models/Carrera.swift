//
//  Carrera.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Carrera: Object, Identifiable {
    // swiftlint:disable identifier_name
    @objc dynamic var id = UUID().uuidString
    // swiftlint:enable identifier_name
    @objc dynamic var sigla: String = ""
    @objc dynamic var enfasis: String = ""
    @objc dynamic var plan: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
