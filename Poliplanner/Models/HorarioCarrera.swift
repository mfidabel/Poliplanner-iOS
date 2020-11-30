//
//  HorarioCarrera.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-27.
//

import Foundation
import RealmSwift

class HorarioCarrera: Object {
    @objc dynamic var secciones: [Seccion]
    @objc dynamic var nombreCarrera: String

    init(conSecciones secciones: [Seccion] = [], llamado nombreCarrera: String) {
        self.secciones = secciones
        self.nombreCarrera = nombreCarrera
    }
}
