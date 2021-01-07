//
//  Array+CarreraSigla.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-03.
//

import Foundation

extension Array where Element == CarreraSigla {
    
    /// Verifica si el vector contiene cierta carrera pasada como argumento
    /// - Parameter carrera: Carrera que deseamos saber si existe dentro del vector
    /// - Returns: Verdadero si es que contiene la carrera, Falso caso contrario
    func contieneCarrera(carrera: CarreraSigla) -> Bool {
        return self.contains { item in
            return item == carrera
        }
    }
    
    /// Verifica si el vector contiene cierta carrera pasada como argumento.
    /// Si la carrera pasada es invalida, devuelve Falso.
    /// - Parameter carrera: Carrera que deseamos saber si existe dentro del vector
    /// - Returns: Verdadero si es que contiene la carrera, Falso caso contrario.
    func contieneCarrera(carrera: String) -> Bool {
        if let carreraSigla = CarreraSigla(rawValue: carrera) {
            return self.contieneCarrera(carrera: carreraSigla)
        } else {
            return false
        }
    }
}
