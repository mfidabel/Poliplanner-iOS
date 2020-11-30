//
//  Revision.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Revision: Object {
    @objc dynamic var fecha: Date
    @objc dynamic var aula: String

    init(fecha: Date, aula: String = "") {
        self.fecha = fecha
        self.aula = aula
    }
}
