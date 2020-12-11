//
//  ConfiguracionView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//

import SwiftUI

struct ConfiguracionView: View {
    var body: some View {
        Form {
            Section {
                NavigationLink(destination: MenuModificarHorarioView()) {
                    Text("Modificar horario")
                }
            }
        }.navigationTitle("Configuración")
    }
}

struct ConfiguracionView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            ConfiguracionView().tabItem {
                Image(systemName: "gear")
                Text("Configuración")
            }
        }
    }
}
