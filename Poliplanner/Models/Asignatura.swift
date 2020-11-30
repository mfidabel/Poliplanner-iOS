//
//  Asignatura.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Asignatura: Object {
    @objc dynamic var departamento: String
    @objc dynamic var nombre: String
    @objc dynamic var nivel: String
    @objc dynamic var semGrupo: String

    init(departamento: String, nombre: String, nivel: String, semGrupo: String) {
        self.departamento = departamento
        self.nombre = nombre
        self.nivel = nivel
        self.semGrupo = semGrupo
    }
}
