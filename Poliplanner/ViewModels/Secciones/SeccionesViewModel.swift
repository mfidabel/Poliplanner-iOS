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
    
    /// Instancia de `Realm` para acceder a la base de datos
    private var realm: Realm = RealmProvider.realm()
    
    // MARK: Resultados
    
    /// Resultado de las secciones elegidas por el usuario
    private var seccionesElegidas: RealmSwift.Results<Seccion>
    
    // MARK: Tokens
    
    /// Token que se obtiene al subscribir a los resultados de las secciones `SeccionesViewModel.seccionesElegidas`
    private var seccionesToken: RealmSwift.NotificationToken?
    
    // MARK: Constructor
    
    /// Constructor del view model.
    /// Se encarga de inicializar los resultados y subscribirse a sus cambios.
    init() {
        // Hacemos el query a secciones elegidas
        seccionesElegidas = realm.objects(Seccion.self)
            .filter("elegido == true AND ANY horariosCarrera.horarioClase.estado == '\(EstadoHorario.ACTIVO.rawValue)'")
        // Almacenamos aquellos solamente que pertenecen a horarios activos
        seccionesActivas = seccionesElegidas.freeze().toArray()
        // Observamos cambios en las secciones activas
        seccionesToken = seccionesElegidas.observe { _ in
            self.seccionesActivas = self.seccionesElegidas.freeze().toArray()
        }
    }
    
    // MARK: Deconstructor
    
    /// Deconstructor del view model.
    /// Se encarga de cancelar las subscripciones a cambios de los resultados.
    deinit {
        // Cancelamos el token
        seccionesToken?.invalidate()
    }
}
