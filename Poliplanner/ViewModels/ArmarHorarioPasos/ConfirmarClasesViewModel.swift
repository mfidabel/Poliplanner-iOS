//
//  ConfirmarClasesViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-26.
//

import Foundation

class ConfirmarClasesViewModel: ObservableObject {
    // MARK: Propiedades
    
    @Published private(set) var paginas: [InfoPaginaDia] = []
    
    // MARK: Constructor
    
    init(secciones: [Seccion]) {
        // Generamos un diccionario de paginas
        var paginasAux: [DiaClase: InfoPaginaDia] = [:]
        
        DiaClase.allCases.forEach { dia in
            paginasAux[dia] = InfoPaginaDia(dia: dia, clases: [])
        }
        
        // Juntamos todas las clases
        secciones.forEach { seccion in
            seccion.clases.forEach { clase in
                let infoGenerada = InfoClase(asignatura: seccion.asignatura!.nombre, clase: clase)
                paginasAux[infoGenerada.dia]!.clases.append(infoGenerada)
            }
        }
        
        // Ordenamos las clases
        self.paginas = DiaClase.allCases.map { dia -> InfoPaginaDia in
            paginasAux[dia]!.clases.sort(by: <)
            return paginasAux[dia]!
        }.sorted()
    }
}
