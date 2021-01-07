//
//  InfoPaginaDia.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
//

import Foundation
import Parchment

/// Representa la información necesaria para generar la pagina de algún dia de la semana en el horario de clases.
struct InfoPaginaDia: Identifiable, Comparable, PagingItem {
    // MARK: - Propiedades
    
    /// Identificador utilizado por Parchment para diferenciar con otras paginas.
    /// Es necesario para cumplir con el protocolo `PagingItem`
    var identifier: Int {
        return id.numero
    }
    
    /// Identificador utilizado para diferenciar `InfoPaginaDia` distintos.
    /// Es necesario para cumplir con el protocolo `Identifiable`
    var id: DiaClase {
        return dia
    }
    
    /// Representa el día de clase (`DiaClase`) que se supone que esta pagina va a mostrar.
    var dia: DiaClase
    
    /// La información de cada clase (`InfoClase`) que se mostrará en esta pagina.
    var clases: [InfoClase]
    
    // MARK: - Protocolo Comparable
    
    /// Permite comparar dos paginas. Decimos que una pagina es menor que la otra si sucede en un día anterior
    /// - Parameters:
    ///   - lhs: Lado izquierdo de la operación binaria <.
    ///   - rhs: Lado derecho de la operación binaria <.
    /// - Returns: Verdadero si el lado izquierdo es menor, Falso caso contrario.
    static func < (lhs: InfoPaginaDia, rhs: InfoPaginaDia) -> Bool {
        lhs.dia < rhs.dia
    }
}
