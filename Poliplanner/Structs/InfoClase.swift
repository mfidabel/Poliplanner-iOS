//
//  InfoClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
//

import Foundation

struct InfoClase: Hashable, Comparable {
    static func < (lhs: InfoClase, rhs: InfoClase) -> Bool {
        if lhs.dia == rhs.dia {
            return lhs.hora < rhs.hora
        }
        
        return lhs.dia < rhs.dia
    }
    
    var dia: DiaClase
    var asignatura: String
    var hora: String
}
