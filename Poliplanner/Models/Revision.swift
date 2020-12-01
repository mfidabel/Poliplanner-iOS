//
//  Revision.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Revision: Object, Identifiable {
    // swiftlint:disable identifier_name
    @objc dynamic var id = UUID().uuidString
    // swiftlint:enable identifier_name
    @objc dynamic var fecha: Date = Date()
    @objc dynamic var aula: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
