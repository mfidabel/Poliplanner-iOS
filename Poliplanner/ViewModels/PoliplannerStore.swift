//
//  PoliplannerStore.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-30.
//

import Foundation
import RealmSwift

// MARK: Store de Poliplanner

/// Store que permite acceder a varios objetos dentro de la base de datos
class PoliplannerStore: ObservableObject {
    // MARK: Shared
    
    /// Instancia compartida del Store. Como `Realm` no soporta instancias entre hilos, esta instancia jamas
    /// deberia ser usada en un hilo distinto al principal. Para usar en otros hilos, se recomienda crear una nueva
    /// instancia
    static let shared = PoliplannerStore(realm: RealmProvider.realm())
    
    // MARK: Propiedades
    
    /// Son las secciones elegidas por el usuario que han sido cargado a la base de datos
    @Published private(set) var seccionesElegidas: RealmSwift.Results<Seccion>
    
    /// Son los horarios de clases que estan en la base de datos
    @Published private(set) var horariosClase: RealmSwift.Results<HorarioClase>
    
    /// Almacena un borrador de horario de clase y es utilizado solamente para pasar borradores
    /// de distintas partes de la aplicación a otras
    @Published var horarioClaseDraft: HorarioClase = HorarioClase()
    
    /// Indica si el usuario tiene horarios cargados
    public var hayHorario: Bool {
        return self.horariosClase.count > 0
    }
    
    /// Instancia de `Realm` para acceder a la base de datos
    private(set) var realm: Realm
    
    // MARK: Resultados
    
    /// Resultado de las secciones elegidas por el usuario
    private var seccionesElegidasResults: RealmSwift.Results<Seccion>
    
    /// Resultado de los horarios de clase del usuario
    private var horariosClaseResults: RealmSwift.Results<HorarioClase>

    // MARK: Tokens
    
    /// Token obtenido al subscribirse a `PoliplannerStore.seccionesElegidasResults`
    private var seccionesElegidasToken: NotificationToken?
    
    /// Token obtenido al subscribirse a `PoliplannerStore.horariosClaseResults`
    private var horariosClaseToken: NotificationToken?

    // MARK: Constructor
    
    /// Constructor de `PoliplannerStore`
    /// - Parameter realm: Instancia de `Realm` que se utilizará para acceder a la base de datos
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

    // MARK: Métodos
    
    /// Se subscribe a los resultados e inicializa los tokens
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

    // MARK: Deconstructor
    
    /// Se encarga de invalidar los tokens de notificación
    deinit {
        seccionesElegidasToken?.invalidate()
        horariosClaseToken?.invalidate()
    }
}
