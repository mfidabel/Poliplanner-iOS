//
//  HorarioClaseView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI

struct HorarioClaseView: View {
    @StateObject private var HCViewModel = HorarioClaseViewModel()

    var body: some View {
        List(HCViewModel.seccionesElegidas) { seccion in
            Text("\(seccion.asignatura?.nombre ?? "Sin nombre")")
        }
    }
}

struct HorarioClaseView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
