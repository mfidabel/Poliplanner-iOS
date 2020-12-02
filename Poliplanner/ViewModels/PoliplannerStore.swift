//
//  PoliplannerStore.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-30.
//

import Foundation
import RealmSwift

class PoliplannerStore: ObservableObject {
    // MARK: - Variables
    @Published private(set) var seccionesElegidas: RealmSwift.Results<Seccion>
    @Published private(set) var horariosClase: RealmSwift.Results<HorarioClase>
    
    public var hayHorario: Bool {
        return self.horariosClase.count > 0
    }
    // MARK: - Resultados
    private var seccionesElegidasResults: RealmSwift.Results<Seccion>
    private var horariosClaseResults: RealmSwift.Results<HorarioClase>

    // MARK: - Tokens
    private var seccionesElegidasToken: NotificationToken?
    private var horariosClaseToken: NotificationToken?

    // MARK: - Realm
    private var realm: Realm

    // MARK: - Inicializador
    init(realm: Realm) {
        // MARK: Inicializar Realm
        self.realm = realm

        // MARK: Inicializar Resultados

        // Seleccionamos las secciones elegidas por el usuario
        seccionesElegidasResults = realm.objects(Seccion.self)
            .filter("elegido = true")
        seccionesElegidas = seccionesElegidasResults.freeze()

        // Seleccionamos los horarios disponibles
        horariosClaseResults = realm.objects(HorarioClase.self)
        horariosClase = horariosClaseResults.freeze()

        // Inicializamos los tokens
        inicializarTokens()
    }

    // MARK: Inicializar Tokens
    private func inicializarTokens() {
        // Observamos cambios sobre los resultados
        seccionesElegidasToken = seccionesElegidasResults.observe { _ in
            self.seccionesElegidas = self.seccionesElegidasResults.freeze()
        }

        // Observamos cambios sobre los horarios
        horariosClaseToken = horariosClaseResults.observe { _ in
            self.horariosClase = self.horariosClaseResults.freeze()
        }
    }

    // MARK: - Limpieza
    deinit {
        seccionesElegidasToken?.invalidate()
    }
}
