//
//  Carrera.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Carrera: Object {
    @objc dynamic var sigla: String
    @objc dynamic var enfasis: String
    @objc dynamic var plan: String

    init(sigla: String = "", enfasis: String = "", plan: String = "") {
        self.sigla = sigla
        self.enfasis = enfasis
        self.plan = plan
    }
}
