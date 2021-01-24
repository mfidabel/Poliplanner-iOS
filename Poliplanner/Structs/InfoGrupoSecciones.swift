//
//  InfoGrupoSecciones.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import Foundation

struct InfoGrupoSecciones: Hashable, Identifiable {
    var carrera: CarreraSigla
    var secciones: [Seccion]
    var id: String { "\(infoAsignatura.nombre) - \(carrera.sigla)" }
    var infoAsignatura: InfoAsignatura {
        secciones.first!.asignatura!.infoAsignatura
    }
}
