//
//  Results+toArray.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-16.
//

import Foundation
import RealmSwift

extension RealmSwift.Results {
    
    /// Convierte el resultado en un vector del elemento
    /// - Returns: Vector del elemento que este resultado busca
    func toArray() -> [Element] {
        return Array(self)
    }
}
