//
//  DateComponents+Referencia.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation

extension DateComponents {
    static var componentesReferencia: DateComponents = {
        var componente = DateComponents()
        componente.calendar = Calendar(identifier: .gregorian)
        componente.timeZone = TimeZone(identifier: "America/Asuncion") ?? .current
        return componente
    }()
}
