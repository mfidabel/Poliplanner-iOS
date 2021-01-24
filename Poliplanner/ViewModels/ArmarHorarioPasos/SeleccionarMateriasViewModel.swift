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
    
    /// Las materias disponibles en la carrera
    private(set) var materiasDisponibles: [InfoAsignatura] = []
    
    /// Conjunto de secciones que el usuario ya seleccionó
    @Published private(set) var materiasSeleccionadas: Set<InfoAsignatura> = []

    /// Horario de clases que se esta usando para mostrar las secciones
    private var horarioClase: HorarioClase
    
    /// Carrera que se usa para saber que secciones mostrar
    let carrera: CarreraSigla
    
    // MARK: Constructor
    
    /// Constructor del View Model
    /// - Parameters:
    ///   - carrera: La carrera que que indica que asignaturas mostrar
    init(paraCarrera carrera: CarreraSigla) {
        self.horarioClase = PoliplannerStore.shared.horarioClaseDraft
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
        
        // Inicializamos las materias disponibles
        var materias = Set<InfoAsignatura>()
        
        // Agarramos las materias sin repetir la información
        for seccion in secciones {
            materias.insert(seccion.asignatura!.infoAsignatura)
        }
        
        // Guardamos las materias ordenadas alfabeticamente por el nombre
        self.materiasDisponibles = Array(materias).sorted { (lhs, rhs) in
            return lhs.nombre < rhs.nombre
        }
    }
    
    func agregarMateria(_ materia: InfoAsignatura) {
        self.materiasSeleccionadas.insert(materia)
    }
    
    func quitarMateria(_ materia: InfoAsignatura) {
        self.materiasSeleccionadas.remove(materia)
    }
    
    func cargarSelecciones(_ selecciones: Set<InfoAsignatura>) {
        self.materiasSeleccionadas = selecciones
    }
}
