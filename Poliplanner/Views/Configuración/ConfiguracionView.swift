//
//  ConfiguracionView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//

import SwiftUI

// MARK: Menú de configuración

/// View principal del menú de configuración
struct ConfiguracionView: View {
    // MARK: Body
    
    var body: some View {
        Form {
            Section {
                NavigationLink(destination: MenuModificarHorarioView()) {
                    Text("Modificar horarios de clases")
                }
            }
        }.navigationTitle("Configuración")
    }
}

// MARK: - Preview

#if DEBUG
/// :nodoc:
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
#endif
