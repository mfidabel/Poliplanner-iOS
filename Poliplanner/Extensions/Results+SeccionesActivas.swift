//
//  Results+SeccionesActivas.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-11.
//

import Foundation
import RealmSwift

extension RealmSwift.Results where ElementType == Seccion {
    /// Busca y devuelve las secciones que pertenecen a un horario de clases activo dentro de los resultados
    /// - Returns: Una lista de secciones congeladas
    func seccionesActivas() -> [Seccion] {
        self.freeze().filter { seccion in
            let horarioCarrera = seccion.horariosCarrera.first as HorarioCarrera?
            let horarioClase = horarioCarrera?.horarioClase.first as HorarioClase?
            return horarioClase?.estado == EstadoHorario.ACTIVO.rawValue
        }
    }
}
