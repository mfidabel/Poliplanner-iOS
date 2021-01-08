//
//  SeleccionarMateriasViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-05.
//

import Foundation
import RealmSwift

// MARK: - View Model para el seleccionador de materias y secciones

/// View Model que controla `ArmarSeleccionarMaterias`
class SeleccionarMateriasViewModel: ObservableObject {
    // MARK: Propiedades
    
    /// Secciones agrupadas por el nombre de su asignatura
    private(set) var materias: [(key: String, value: [Seccion])] = []
    
    /// Conjunto de secciones que el usuario ya seleccionó
    @Published private(set) var seccionesSeleccionadas: Set<Seccion> = []

    /// Horario de clases que se esta usando para mostrar las secciones
    private var horarioClase: HorarioClase
    
    /// Carrera que se usa para saber que secciones mostrar
    private var carrera: CarreraSigla
    
    // MARK: Constructor
    
    /// Constructor del View Model
    /// - Parameters:
    ///   - horarioClase: Horario de clases de donde se van a sacar las materias
    ///   - carrera: La carrera que que indica que asignaturas mostrar
    init(horarioClase: HorarioClase, paraCarrera carrera: CarreraSigla) {
        self.horarioClase = horarioClase
        self.carrera = carrera
        agruparMaterias()
    }
    
    // MARK: Métodos
    
    /// Se encarga de agrupar las secciones por el nombre de la asignatura
    private func agruparMaterias() {
        // Obtener el horario de carreras
        let horarioCarrera = self.horarioClase
            .horariosCarrera.first { horario in
                return horario.carrera == carrera
            }!
        
        // Obtener las secciones
        let secciones = horarioCarrera.secciones
        
        // Agrupar por su nombre
        self.materias = Array(Dictionary(grouping: secciones) { seccion in
            return seccion.asignatura!.nombre
        })
        
        // Ordernar alfabeticamente
        self.materias.sort { (izquierda, derecha) in
            return izquierda.key < derecha.key
        }
    }
    
    /// Selecciona una sección de una materia.
    /// Si ya se seleccionó otra sección de la misma materia, esta se deselecciona y se elige la nueva sección
    /// - Parameter seccion: Sección que se desea seleccionar
    func agregarSeccion(_ seccion: Seccion) {
        // Buscar si existe una sección de la misma
        let seccionMateria = seccionesSeleccionadas.first { seccionSeleccionada in
            return seccionSeleccionada.asignatura?.nombre == seccion.asignatura?.nombre
        }
        
        // Eliminar la sección de misma materia
        if seccionMateria != nil {
            seccionesSeleccionadas.remove(seccionMateria!)
        }
        
        // Insertar nueva sección
        seccionesSeleccionadas.insert(seccion)
    }
    
    /// Deselecciona una sección previamente seleccionada
    /// - Parameter seccion: Sección que se desea deseleccionar
    func quitarSeccion(_ seccion: Seccion) {
        seccionesSeleccionadas.remove(seccion)
    }
    
    /// Revisa si es que la sección ya esta seleccionada o no.
    /// - Parameter seccion: Sección que se desea saber si esta seleccionada
    /// - Returns: Verdadero si es que esta seleccionado, Falso caso contrario
    func seccionSeleccionada(_ seccion: Seccion) -> Bool {
        return seccionesSeleccionadas.contains(seccion)
    }
    
    /// Carga las secciones como secciones elegidas
    func cargarSecciones() {
        // Marcamos todas las secciones como elegidas
        seccionesSeleccionadas.forEach { seccion in
            seccion.elegido = true
        }
        
        // Marcamos el horario como activo TODO: Desmarcar otros horarios como activos
        horarioClase.estado = EstadoHorario.ACTIVO.rawValue
        
        // Escribimos los cambios
        let realm = RealmProvider.realm()
        
        try? realm.write {
            realm.add(horarioClase)
        }
    }
}
