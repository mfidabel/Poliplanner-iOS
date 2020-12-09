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
    var clasesPorDia: [ (key: DiaClase, value: [InfoClase]) ] {
        // Juntamos todas las clases
        let clases: [InfoClase] = seccionesElegidasActivas.flatMap { seccion in
            seccion.clases.map { clase in
                InfoClase(dia: DiaClase(rawValue: clase.dia)!,
                          asignatura: seccion.asignatura!.nombre,
                          hora: clase.horaInicio)
            }
        }.sorted { (claseIzquierda, claseDerecha) -> Bool in
            claseIzquierda.hora < claseDerecha.hora
        }
        // Retornamos un vector ordenado con las tuplas agrupadas por el dia
        return Dictionary(grouping: clases) { clase in
            clase.dia
        }.sorted { (diaIzquierdo, diaDerecho) in
            diaIzquierdo.key < diaDerecho.key
        }
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
