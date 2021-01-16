//
//  HorarioClaseViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import Foundation
import RealmSwift

// MARK: - View Model que controla los horarios

/// View Model encargado de controlar `HorarioClaseView`
class HorarioClaseViewModel: ObservableObject {
    // MARK: Propiedades
    
    /// Secciones elegidas por el usuario previamente. Son estas secciones las que se usaran para mostrar las clases
    @Published private(set) var seccionesElegidasActivas: [Seccion] = []
    
    /// Agrupa las clases por día en páginas que se utilizarán luego para mostrar en listas
    var clasesPorDia: [InfoPaginaDia] {
        // Generamos un diccionario de paginas
        var paginas: [DiaClase: InfoPaginaDia] = [:]
        
        DiaClase.allCases.forEach { dia in
            paginas[dia] = InfoPaginaDia(dia: dia, clases: [])
        }
        
        // Juntamos todas las clases
        seccionesElegidasActivas.forEach { seccion in
            seccion.clases.forEach { clase in
                let infoGenerada = InfoClase(asignatura: seccion.asignatura!.nombre, clase: clase)
                paginas[infoGenerada.dia]!.clases.append(infoGenerada)
            }
        }
        
        // Ordenamos las clases
        return DiaClase.allCases.map { dia -> InfoPaginaDia in
            paginas[dia]!.clases.sort(by: <)
            return paginas[dia]!
        }.sorted()
    }
    
    /// Instancia de `Realm` para acceder a la base de datos
    private var realm: Realm = RealmProvider.realm()
    
    // MARK: Resultados
    
    /// Resultados de las secciones elegidas
    private var seccionesElegidasResults: RealmSwift.Results<Seccion>

    // MARK: Tokens
    
    /// Token que se obtiene al subscribir a `HorarioClaseViewModel.seccionesElegidasResults`
    private var seccionesElegidasToken: NotificationToken?
    
    // MARK: Constructor
    
    /// Se encarga de inicializar los resultados y cargar las secciones
    init() {
        // Seleccionamos las secciones elegidas por el usuario
        seccionesElegidasResults = realm.objects(Seccion.self)
            .filter("elegido == true AND ANY horariosCarrera.horarioClase.estado == '\(EstadoHorario.ACTIVO.rawValue)'")
        seccionesElegidasActivas = self.seccionesElegidasResults.freeze().toArray()
        inicializarTokens()
    }
    
    // MARK: Métodos
    
    /// Se encarga de subscribirse a los resultados y generar los tokens de estos
    private func inicializarTokens() {
        // Observamos cambios sobre los resultados
        seccionesElegidasToken = seccionesElegidasResults.observe { _ in
            // Cargar todas las secciones elegidas
            self.seccionesElegidasActivas = self.seccionesElegidasResults.freeze().toArray()
        }
    }
    
    // MARK: Deconstructor
    
    /// Se encarga de cancelar las subscripciones a los resultados
    deinit {
        seccionesElegidasToken?.invalidate()
    }
}
