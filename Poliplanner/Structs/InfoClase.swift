//
//  InfoClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
//

import Foundation

/// Representa la estructura de datos de una clase en el horario de clases que se mostrará.
/// Es una entrada en la lista de clases de un cierto dia.
struct InfoClase: Hashable, Comparable {
    static func < (lhs: InfoClase, rhs: InfoClase) -> Bool {
        if lhs.dia == rhs.dia {
            return lhs.hora < rhs.hora
        }
        
        return lhs.dia < rhs.dia
    }
    
    init(asignatura: String, clase: Clase) {
        self.asignatura = asignatura
        self.clase = clase
    }
    
    private var clase: Clase
    
    var asignatura: String
    var dia: DiaClase {
        return DiaClase(rawValue: clase.dia)!
    }
    var hora: String {
        return clase.horaInicio
    }
    var aula: String {
        return clase.aula
    }
}
