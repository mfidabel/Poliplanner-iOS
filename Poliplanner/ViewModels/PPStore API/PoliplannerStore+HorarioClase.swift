//
//  PoliplannerStore+HorarioClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-12.
//

import Foundation

// MARK: - Poliplanner Store + HorarioClase

extension PoliplannerStore {
    // MARK: HorarioClase API
    
    /// Alterna el estado de un horario por el estado que se pasó como argumento
    /// - Parameters:
    ///   - horarioClase: Horario de clases que se trata de modificar
    ///   - estado: Estado de horario que se desea asignar al horario de clases
    func alternarEstadoHorario(_ horarioClase: HorarioClase, estado: EstadoHorario) {
        // Obtenemos el horario de clases manejado por Realm
        guard let horario = horarioClase.isFrozen
            ? realm.object(ofType: HorarioClase.self, forPrimaryKey: horarioClase.id)
            : horarioClase
        else {
            print("Se trató de modificar un horario que no esta manejado por Realm")
            return
        }
        
        // Tratamos de escribir los cambios
        do {
            try realm.write {
                horario.estadoEnum = estado
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Elimina el horario de clase pasado como argumento si es que este existiere en la base de datos
    /// - Parameter horarioClase: Horario de clases que se trata de eliminar
    func eliminarHorario(_ horarioClase: HorarioClase) {
        // Obtenemos el horario de clases manejado por Realm
        guard let horario = horarioClase.isFrozen
            ? realm.object(ofType: HorarioClase.self, forPrimaryKey: horarioClase.id)
            : horarioClase
        else {
            print("Se trató de eliminar un horario que no esta manejado por Realm")
            return
        }
        
        // Tratamos de eliminar
        do {
            try realm.write {
                // Eliminamos el horario y todo lo que le sigue en cascada
                realm.cascadingDelete(horario)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Cambia el nombre de un horario de clases
    /// - Parameters:
    ///   - horarioClase: Horario de clases que se esta intentando modificar
    ///   - nombre: Nombre que se desea que tenga el horario de clases luego de la modificación
    func cambiarNombreHorario(_ horarioClase: HorarioClase, a nombre: String) {
        // Obtenemos el horario de clases manejado por Realm
        guard let horario = horarioClase.isFrozen
            ? realm.object(ofType: HorarioClase.self, forPrimaryKey: horarioClase.id)
            : horarioClase
        else {
            print("Se trató de editar un horario que no esta manejado por Realm")
            return
        }
        
        // Tratamos de editar
        do {
            try realm.write {
                // Eliminamos el horario y todo lo que le sigue en cascada
                horario.nombre = nombre
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Cambia el periodo académico de un horario de clases
    /// - Parameters:
    ///   - horarioClase: Horario de clases que se esta intentando modificar
    ///   - periodo: Periodo académico que se desea que tenga el horario de clases luego de la modificación
    func cambiarPeriodoHorario(_ horarioClase: HorarioClase, a periodo: String) {
        // Obtenemos el horario de clases manejado por Realm
        guard let horario = horarioClase.isFrozen
            ? realm.object(ofType: HorarioClase.self, forPrimaryKey: horarioClase.id)
            : horarioClase
        else {
            print("Se trató de editar un horario que no esta manejado por Realm")
            return
        }
        
        // Tratamos de editar
        do {
            try realm.write {
                // Eliminamos el horario y todo lo que le sigue en cascada
                horario.periodoAcademico = periodo
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Cambia la fecha de actualización del horario de clases
    /// - Parameters:
    ///   - horarioClase: Horario de clases que se esta intentando modificar
    ///   - fecha: Fecha de actualización que se desea que tenga el horario de clases luego de la modificación
    func cambiarFechaActualizacionHorario(_ horarioClase: HorarioClase, a fecha: String) {
        // Obtenemos el horario de clases manejado por Realm
        guard let horario = horarioClase.isFrozen
            ? realm.object(ofType: HorarioClase.self, forPrimaryKey: horarioClase.id)
            : horarioClase
        else {
            print("Se trató de editar un horario que no esta manejado por Realm")
            return
        }
        
        // Tratamos de editar
        do {
            try realm.write {
                // Eliminamos el horario y todo lo que le sigue en cascada
                horario.fechaActualizacion = fecha
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
