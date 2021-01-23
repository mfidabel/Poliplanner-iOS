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
    
    // MARK: Safe
    
    /// Genera una instancia segura para cualquier hilo que lo llame. Como `Realm` no soporta instancias entre hilos,
    /// cada instancia segura debe usarse solamente en el hilo que lo llamó.
    static var safe: PoliplannerStore {
        PoliplannerStore(realm: RealmProvider.realm())
    }
    
    // MARK: Propiedades
    
    /// Son las secciones elegidas y activas congeladas por el usuario que han sido cargado a la base de datos
    @Published private(set) var seccionesElegidasActivas: RealmSwift.Results<Seccion>
    
    /// Son los horarios de clases congelados que estan en la base de datos
    @Published private(set) var horariosClase: RealmSwift.Results<HorarioClase>
    
    /// Son los exámenes de las secciones activas en la base de datos
    @Published private(set) var examenesActivos: RealmSwift.Results<Examen>
    
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
    
    /// Resultados de las secciones elegidas por el usuario
    private(set) var seccionesElegidasResults: RealmSwift.Results<Seccion>
    
    /// Resultados de los horarios de clase del usuario
    private(set) var horariosClaseResults: RealmSwift.Results<HorarioClase>
    
    /// Resultados de los horarios de clase del usuarios que estan activos
    private(set) var horariosClaseActivosResults: RealmSwift.Results<HorarioClase>
    
    /// Resultados de los exámenes de secciones elegidas por el usuario que pertenecen a un horario activo
    private(set) var examenesActivosResults: RealmSwift.Results<Examen>

    // MARK: Tokens
    
    /// Token obtenido al subscribirse a `PoliplannerStore.seccionesElegidasResults`
    private var seccionesElegidasToken: NotificationToken?
    
    /// Token obtenido al subscribirse a `PoliplannerStore.horariosClaseResults`
    private var horariosClaseToken: NotificationToken?
    
    /// Token obtenido al subscribirse a `PoliplannerStore.examenesActivosResults`
    private var examenesActivosToken: NotificationToken?

    // MARK: Constructor
    
    /// Constructor de `PoliplannerStore`
    /// - Parameter realm: Instancia de `Realm` que se utilizará para acceder a la base de datos
    init(realm: Realm) {
        // MARK: Inicializar Realm
        self.realm = realm

        // MARK: Inicializar Resultados

        // Seleccionamos las secciones elegidas por el usuario
        seccionesElegidasResults = realm.objects(Seccion.self)
            .filter("elegido == true AND ANY horariosCarrera.horarioClase.estado == '\(EstadoHorario.ACTIVO.rawValue)'")
        
        // Seleccionamos los horarios disponibles
        horariosClaseResults = realm.objects(HorarioClase.self)
        
        // Seleccionamos los horarios activos
        horariosClaseActivosResults = horariosClaseResults
            .filter("estado == '\(EstadoHorario.ACTIVO.rawValue)'")
        
        // Seleccionamos los examenes activos
        examenesActivosResults = realm.objects(Examen.self)
            .filter("ANY secciones.elegido == true")
            .filter("ANY secciones.horariosCarrera.horarioClase.estado == '\(EstadoHorario.ACTIVO.rawValue)'")
        
        // MARK: Inicializar Resultados congelados
        
        seccionesElegidasActivas = seccionesElegidasResults.freeze()
        
        horariosClase = horariosClaseResults.freeze()
        
        examenesActivos = examenesActivosResults.freeze()
        
        // MARK: Inicializar Tokens de notificación
        
        seccionesElegidasToken = seccionesElegidasResults.observe { _ in
            self.seccionesElegidasActivas = self.seccionesElegidasResults.freeze()
        }
        
        horariosClaseToken = horariosClaseResults.observe { _ in
            self.horariosClase = self.horariosClaseResults.freeze()
        }
        
        examenesActivosToken = examenesActivosResults.observe { _ in
            self.examenesActivos = self.examenesActivosResults.freeze()
        }
        
    }
    
    // MARK: Deconstructor
    
    /// Limpieza
    deinit {
        seccionesElegidasToken?.invalidate()
        horariosClaseToken?.invalidate()
        examenesActivosToken?.invalidate()
    }
}
