//
//  SeccionesViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-11.
//

import Foundation
import RealmSwift

class SeccionesViewModel: ObservableObject {
    // MARK: - Variables
    @Published private(set) var seccionesActivas: [Seccion] = []
    
    // MARK: - Resultados
    private var seccionesElegidas: RealmSwift.Results<Seccion>
    
    // MARK: - Tokens
    private var seccionesToken: RealmSwift.NotificationToken?
    
    // MARK: - Realm
    private var realm: Realm = RealmProvider.realm()
    
    init() {
        // Hacemos el query a secciones elegidas
        seccionesElegidas = realm.objects(Seccion.self)
            .filter("elegido = true")
        // Almacenamos aquellos solamente que pertenecen a horarios activos
        seccionesActivas = seccionesElegidas.seccionesActivas()
        // Observamos cambios en las secciones activas
        seccionesToken = seccionesElegidas.observe { _ in
            self.seccionesActivas = self.seccionesElegidas.seccionesActivas()
        }
    }
    
    deinit {
        // Cancelamos el token
        seccionesToken?.invalidate()
    }
}
