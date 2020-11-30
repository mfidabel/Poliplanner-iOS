//
//  Examen.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Examen: Object {
    @objc dynamic var fecha: Date
    @objc dynamic var aula: String
    @objc dynamic var revision: Revision?

    init(fecha: Date, aula: String = "", revision: Revision?) {
        self.fecha = fecha
        self.aula = aula
        self.revision = revision
    }
}
