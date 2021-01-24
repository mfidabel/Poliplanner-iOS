//
//  SeleccionarSeccionesViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import Foundation

class SeleccionarSeccionesViewModel: ObservableObject {
    // MARK: Propiedades
    
    private(set) var seccionesAgrupadas: [InfoGrupoSecciones] = []
    
    @Published var seccionesSeleccionadas: Set<Seccion> = []
    
    init(materiasSeleccionadas: [CarreraSigla: Set<InfoAsignatura>]) {
        let horarioClase = PoliplannerStore.shared.horarioClaseDraft
        
        // Agrupamos las secciones
        for (carrera, asignaturas) in materiasSeleccionadas {
            let seccionesCandidatos = horarioClase.horariosCarrera
                .first { $0.carrera == carrera }!
                .secciones
                .filter { asignaturas.contains($0.asignatura!.infoAsignatura) }
            let gruposCarrera =
                Dictionary(grouping: seccionesCandidatos) { $0.asignatura!.infoAsignatura }
                .map { InfoGrupoSecciones(carrera: carrera, secciones: $0.value) }
            
            seccionesAgrupadas.append(contentsOf: gruposCarrera)
        }
    }
    
    func agregarSeccion(_ seccion: Seccion) {
        let duplicado = seccionesSeleccionadas.first {
            $0.asignatura!.infoAsignatura == seccion.asignatura!.infoAsignatura
        }
        
        if duplicado != nil {
            seccionesSeleccionadas.remove(duplicado!)
        }
        
        seccionesSeleccionadas.insert(seccion)
    }
    
    func quitarSeccion(_ seccion: Seccion) {
        seccionesSeleccionadas.remove(seccion)
    }
}
