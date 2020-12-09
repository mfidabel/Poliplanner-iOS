//
//  HorarioClaseViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import Foundation
import RealmSwift

class HorarioClaseViewModel: ObservableObject {
    // MARK: - Variables
    @Published private(set) var seccionesElegidas: RealmSwift.Results<Seccion>
    
    // MARK: - Results
    private var seccionesElegidasResults: RealmSwift.Results<Seccion>

    // MARK: - Tokens
    private var seccionesElegidasToken: NotificationToken?
    
    // MARK: - Realm
    private var realm: Realm = RealmProvider.realm()
    
    // MARK: Inicializador
    init() {
        // Seleccionamos las secciones elegidas por el usuario
        seccionesElegidasResults = realm.objects(Seccion.self)
            .filter("elegido = true")
        seccionesElegidas = seccionesElegidasResults.freeze()
        inicializarTokens()
    }
    
    // MARK: Inicializar Tokens
    private func inicializarTokens() {
        // Observamos cambios sobre los resultados
        seccionesElegidasToken = seccionesElegidasResults.observe { _ in
            // Cargar todas las secciones elegidas
            self.seccionesElegidas = self.seccionesElegidasResults.freeze()
        }
    }
    
    // MARK: Cleanup
    deinit {
        seccionesElegidasToken?.invalidate()
    }
}
