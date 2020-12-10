//
//  InfoPaginaDia.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
//

import Foundation
import Parchment

struct InfoPaginaDia: Identifiable, Comparable, PagingItem {
    var identifier: Int {
        return id.numero
    }
    
    // swiftlint:disable identifier_name
    var id: DiaClase {
        return dia
    }
    // swiftlint:enable identifier_name
    var dia: DiaClase
    var clases: [InfoClase]
    
    static func < (lhs: InfoPaginaDia, rhs: InfoPaginaDia) -> Bool {
        lhs.dia < rhs.dia
    }
}
