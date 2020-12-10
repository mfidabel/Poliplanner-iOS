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
    @Published private(set) var seccionesElegidasActivas: [Seccion] = []
    var clasesPorDia: [InfoPaginaDia] {
        // Generamos un diccionario de paginas
        var paginas: [DiaClase: InfoPaginaDia] = [:]
        
        DiaClase.allCases.forEach { dia in
            paginas[dia] = InfoPaginaDia(dia: dia, clases: [])
        }
        
        // Juntamos todas las clases
        seccionesElegidasActivas.forEach { seccion in
            seccion.clases.forEach { clase in
                let infoGenerada = InfoClase(dia: DiaClase(rawValue: clase.dia)!,
                          asignatura: seccion.asignatura!.nombre,
                          hora: clase.horaInicio)
                paginas[infoGenerada.dia]!.clases.append(infoGenerada)
            }
        }
        
        // Ordenamos las clases
        return DiaClase.allCases.map { dia -> InfoPaginaDia in
            paginas[dia]!.clases.sort(by: <)
            return paginas[dia]!
        }.sorted()
    }
    
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
        seleccionarSeccionesActivasElegidas()
        inicializarTokens()
    }
    
    // MARK: Inicializar Tokens
    private func inicializarTokens() {
        // Observamos cambios sobre los resultados
        seccionesElegidasToken = seccionesElegidasResults.observe { _ in
            // Cargar todas las secciones elegidas
            self.seleccionarSeccionesActivasElegidas()
        }
    }
    
    private func seleccionarSeccionesActivasElegidas() {
        seccionesElegidasActivas = seccionesElegidasResults.freeze().filter { seccion in
            let horarioCarrera = seccion.horariosCarrera.first as HorarioCarrera?
            let horarioClase = horarioCarrera?.horarioClase.first as HorarioClase?
            return horarioClase?.estado == EstadoHorario.ACTIVO.rawValue
        }
    }
    
    // MARK: Cleanup
    deinit {
        seccionesElegidasToken?.invalidate()
    }
}
