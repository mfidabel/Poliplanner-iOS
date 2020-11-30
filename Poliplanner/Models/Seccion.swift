//
//  Seccion.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Seccion: Object {
    @objc dynamic var asignatura: Asignatura?
    @objc dynamic var carrera: Carrera?
    @objc dynamic var examenes: [Examen]
    @objc dynamic var clases: [Clase]
    @objc dynamic var docente: String
    @objc dynamic var codigo: String

    init(asignatura: Asignatura, carrera: Carrera?, conExamenes examenes: [Examen] = [],
         conClases clases: [Clase] = [], docente: String = "", codigo: String = "") {
        self.asignatura = asignatura
        self.carrera = carrera
        self.examenes = examenes
        self.clases = clases
        self.docente = docente
        self.codigo = codigo
    }
}
