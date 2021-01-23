//
//  SeccionesViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-11.
//

import Foundation
import RealmSwift

// MARK: - View Model de Secciones

/// View Model de las secciones, se encarga de manejar que secciones son las que se van a mostrar
class SeccionesViewModel: ObservableObject {
    // MARK: Propiedades
    
    /// Una lista de las secciones elegidas que se va a mostrar al usuario
    @Published private(set) var seccionesActivas: [Seccion] = []
    
    // MARK: Constructor
    
    /// Constructor del view model.
    /// Se encarga de inicializar las secciones activas y hacer que 
    init() {
        // Hacemos que las secciones se actualicen cada vez que cambian las secciones elegidas
        PoliplannerStore.shared.$seccionesElegidasActivas
            .map { $0.toArray() }
            .assign(to: &$seccionesActivas)
    }
}
