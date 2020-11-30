//
//  Clase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Clase: Object {
    @objc dynamic var dia: String
    @objc dynamic var horaInicio: String
    @objc dynamic var horaFin: String
    @objc dynamic var aula: String

    init(dia: String, horaInicio: String, horaFin: String, aula: String) {
        self.dia = dia
        self.horaInicio = horaInicio
        self.horaFin = horaFin
        self.aula = aula
    }
}
