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
        VStack {
            PaginacionMateriaView(paginas: HCViewModel.clasesPorDia)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
