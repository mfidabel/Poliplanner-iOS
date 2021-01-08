//
//  HorarioClaseView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI

// MARK: Sección de Horarios de Clase

/// View Principal donde se ven las clases por cada día en páginas
struct HorarioClaseView: View {
    // MARK: Propiedades
    
    /// View Model que controla este View
    @ObservedObject private var HCViewModel = HorarioClaseViewModel()

    // MARK: Body
    
    var body: some View {
        PaginacionMateriaView(paginas: HCViewModel.clasesPorDia)
            .navigationBarTitle("Horario de clases", displayMode: .automatic)
    }
}
