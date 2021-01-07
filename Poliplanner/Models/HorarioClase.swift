//
//  HorarioClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-27.
//

import Foundation
import RealmSwift

/// Modelo que representa un horario de clases
class HorarioClase: Object, Identifiable {
    // MARK: - Propiedades
    
    /// Identificador del horario
    @objc dynamic var id = UUID().uuidString
    
    /// Nombre del horario
    @objc dynamic var nombre: String = ""
    
    /// Fecha de actualización del horario
    @objc dynamic var fechaActualizacion: String = ""
    
    /// Periodo Academico del horario
    @objc dynamic var periodoAcademico: String = ""
    
    /// Estado del horario de clases
    @objc dynamic var estado: String = EstadoHorario.DRAFT.rawValue
    
    /// Horarios de carrera
    let horariosCarrera: List<HorarioCarrera> = List<HorarioCarrera>()
    
    // MARK: - Métodos
    
    /// Función auxiliar que permite a `Realm` identificar los horarios de clase por su id en la base de datos.
    override static func primaryKey() -> String? {
        return "id"
    }
}
