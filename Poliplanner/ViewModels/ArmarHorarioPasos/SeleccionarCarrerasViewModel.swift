//
//  SeleccionarCarrerasViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import Foundation
import RealmSwift

/// ViewModel que controla el view `ArmarSeleccionarCarrera`
class SeleccionarCarrerasViewModel: ObservableObject {
    // MARK: Propiedades
    
    /// Indica las carreras disponibles en el horario de clases
    @Published private(set) var carrerasDisponibles: [CarreraSigla]
    
    /// Indica las carreras seleccionadas por el usuario en el view
    @Published private(set) var carrerasSeleccionadas: Set<CarreraSigla> = []
    
    // MARK: Métodos
    
    /// Agrega el horario de la carrera al conjunto de carreras seleccionadas
    /// - Parameter carrera: Horario de la carrera que se esta agregamdo
    func agregarCarrera(_ carrera: CarreraSigla) {
        carrerasSeleccionadas.insert(carrera)
    }
    
    /// Elimina el horario de la carrera al conjunto de carreras seleccionadas
    /// - Parameter carrera: Horario de la carrera que se esta eliminando
    func eliminarCarrera(_ carrera: CarreraSigla) {
        carrerasSeleccionadas.remove(carrera)
    }
    
    // MARK: Constructor
    
    /// Constructor del ViewModel
    /// Inicializa la lista de carreras disponibles en el borrador de horario de clases y se subscribe a sus cambios
    init() {
        // Inicializamos la lista
        carrerasDisponibles = PoliplannerStore.shared.horarioClaseDraft.horariosCarrera.map { $0.carrera }
        
        // Republicamos los horarios de carrera disponible
        PoliplannerStore.shared.$horarioClaseDraft
            .map { $0.horariosCarrera.map { $0.carrera } }
            .assign(to: &$carrerasDisponibles)
    }
    
}
