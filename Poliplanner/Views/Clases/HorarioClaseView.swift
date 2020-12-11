//
//  HorarioClaseView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI

struct HorarioClaseView: View {
    @ObservedObject private var HCViewModel = HorarioClaseViewModel()

    var body: some View {
        PaginacionMateriaView(paginas: HCViewModel.clasesPorDia)
            .navigationBarTitle("Horario de clases", displayMode: .automatic)
    }
}
