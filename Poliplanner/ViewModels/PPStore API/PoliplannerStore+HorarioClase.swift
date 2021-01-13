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
}
