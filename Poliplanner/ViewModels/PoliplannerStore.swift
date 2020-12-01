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

    // MARK: - Resultados
    private var seccionesElegidasResults: RealmSwift.Results<Seccion>

    // MARK: - Tokens
    private var seccionesElegidasToken: NotificationToken?

    // MARK: - Realm
    private var realm: Realm

    // MARK: - Inicializador
    init(realm: Realm) {
        self.realm = realm
        // Seleccionamos las secciones elegidas por el usuario
        seccionesElegidasResults = realm.objects(Seccion.self).filter("elegido = true")
        seccionesElegidas = seccionesElegidasResults.freeze()
        // Observamos cambios sobre los resultados
        seccionesElegidasToken = seccionesElegidasResults.observe { _ in
            self.seccionesElegidas = self.seccionesElegidasResults.freeze()
        }
    }

    // MARK: - Limpieza
    deinit {
        seccionesElegidasToken?.invalidate()
    }
}
