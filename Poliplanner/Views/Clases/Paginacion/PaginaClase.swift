//
//  PaginaClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
//

import SwiftUI

struct PaginaClase: View {
    let pagina: InfoPaginaDia
    
    var body: some View {
        List {
            ForEach(pagina.clases, id: \.self) { clase in
                Text("\(clase.asignatura) \(clase.hora)")
            }
        }
    }
}
