//
//  HorarioClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-27.
//

import Foundation
import RealmSwift

class HorarioClase: Object {
    @objc dynamic var horariosCarrera: [HorarioCarrera]
    @objc dynamic var nombre: String
    @objc dynamic var fechaActualizacion: String
    @objc dynamic var periodoAcademico: String

    init(horarios horariosCarrera: [HorarioCarrera] = [], llamado nombre: String,
         fechaActualizacion: String, delPeriodo periodoAcademico: String) {
        self.horariosCarrera = horariosCarrera
        self.nombre = nombre
        self.fechaActualizacion = fechaActualizacion
        self.periodoAcademico = periodoAcademico
    }
}
