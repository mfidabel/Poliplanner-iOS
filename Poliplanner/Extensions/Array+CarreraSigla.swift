//
//  Array+CarreraSigla.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-03.
//

import Foundation

extension Array where Element == CarreraSigla {
    func contieneCarrera(carrera: CarreraSigla) -> Bool {
        return self.contains { item in
            return item == carrera
        }
    }
    
    func contieneCarrera(carrera: String) -> Bool {
        if let carreraSigla = CarreraSigla(rawValue: carrera) {
            return self.contieneCarrera(carrera: carreraSigla)
        } else {
            return false
        }
    }
}
