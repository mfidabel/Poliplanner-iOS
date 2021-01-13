//
//  HorarioClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-27.
//

import Foundation
import RealmSwift

/// Modelo que representa un horario de clases
class HorarioClase: RealmSwift.Object, Identifiable, CascadingDeletable {
    // MARK: Propiedades
    
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
    
    /// Si el horario esta activo y mostrandose o no
    var activo: Bool {
        get {
            estado == EstadoHorario.ACTIVO.rawValue
        }
        set {
            if newValue {
                estado = EstadoHorario.ACTIVO.rawValue
            } else {
                estado = EstadoHorario.INACTIVO.rawValue
            }
        }
    }
    
    /// Funciona de puente con el estado del horario `HorarioClase.estado`
    var estadoEnum: EstadoHorario {
        get {
            EstadoHorario(rawValue: estado)!
        }
        set {
            estado = newValue.rawValue
        }
    }
    
    // MARK: Protocolo CascadingDeletable
    
    /// Propiedades que se eliminarán si se elimina este objeto
    static var propertiesToCascadeDelete: [String] = ["horariosCarrera"]
    
    // MARK: Métodos
    
    /// Función auxiliar que permite a `Realm` identificar los horarios de clase por su id en la base de datos.
    override static func primaryKey() -> String? {
        return "id"
    }
}
