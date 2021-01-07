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
    // MARK: - Propiedades
    
    /// Clase que se esta representando.
    private var clase: Clase
    
    /// Nombre de la asignatura que se va a mostrar en la lista de clases.
    var asignatura: String
    
    /// Dia de clase al que pertenece esta entrada.
    var dia: DiaClase {
        return DiaClase(rawValue: clase.dia)!
    }
    
    /// Hora de la clase que se mostrará en la lista de clases.
    var hora: String {
        return clase.horaInicio
    }
    
    /// Aula de la clase que se mostrará en la lista de clases
    var aula: String {
        return clase.aula
    }
    
    // MARK: - Inicializador
    
    /// Constructor de la estructura.
    /// - Parameters:
    ///   - asignatura: Nombre de la asignatura que se desea mostrar en la lista de clases
    ///   - clase: Clase de donde se obtendran los datos a mostrar.
    init(asignatura: String, clase: Clase) {
        self.asignatura = asignatura
        self.clase = clase
    }
    
    // MARK: - Protocolo Comparable
    
    /// Función que permite comparar dos `InfoClase`.
    /// Se ordena por tiempo de ocurrencia, se prioriza el día de la semana y luego la hora.
    /// - Parameters:
    ///   - lhs: Lado izquierdo de la operación binaria <.
    ///   - rhs: Lado derecho de la operación binaria <.
    /// - Returns: Verdadero cuando es menor el lado izquierdo, falso caso contrario
    static func < (lhs: InfoClase, rhs: InfoClase) -> Bool {
        if lhs.dia == rhs.dia {
            return lhs.hora < rhs.hora
        }
        
        return lhs.dia < rhs.dia
    }
}
