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
        Group {
            List {
                ForEach(HCViewModel.clasesPorDia, id: \.key) { dia in
                    Section(header: Text(dia.key.rawValue)) {
                        ForEach(dia.value, id: \.self) { clase in
                            Text("\(clase.asignatura) \(clase.hora)")
                        }
                    }
                }
            }
        }
    }
}
