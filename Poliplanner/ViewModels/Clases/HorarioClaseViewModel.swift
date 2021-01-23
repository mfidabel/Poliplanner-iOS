//
//  HorarioClaseViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import Foundation
import RealmSwift
import Combine

// MARK: - View Model que controla los horarios

/// View Model encargado de controlar `HorarioClaseView`
class HorarioClaseViewModel: ObservableObject {
    // MARK: Propiedades
    
    /// Representa las páginas que se van a mostrar en el horario
    @Published private(set) var clasesPorDia: [InfoPaginaDia]!

    // MARK: Constructor
    
    /// Se encarga de inicializar las páginas y subscribirse cada vez que cambian las secciones
    init() {
        // Inicializamos las páginas
        clasesPorDia = cargarPaginas(para: PoliplannerStore.shared.seccionesElegidasActivas)
        
        // Generamos páginas cada vez que cambian las secciones activas elegidas
        PoliplannerStore.shared.$seccionesElegidasActivas
            .map(cargarPaginas(para:))
            .assign(to: &$clasesPorDia)
    }
    
    // MARK: Métodos
    
    private func cargarPaginas(para secciones: RealmSwift.Results<Seccion>) -> [InfoPaginaDia] {
        // Generamos un diccionario de paginas
        var paginas: [DiaClase: InfoPaginaDia] = [:]
        
        DiaClase.allCases.forEach { dia in
            paginas[dia] = InfoPaginaDia(dia: dia, clases: [])
        }
        
        // Juntamos todas las clases
        secciones.forEach { seccion in
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
}
