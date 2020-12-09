//
//  ContentView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 11/25/20.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            HorarioClaseView()
                .tabItem {
                    Label("Clases", systemImage: "list.bullet")
                }.tag("0")
            CalendarioView()
                .tabItem {
                    Label("Calendario", systemImage: "calendar")
                }
                .tag("1")
            SeccionesView()
                .tabItem {
                    Label("Secciones", systemImage: "rectangle.grid.1x2")
                }
                .tag("2")
            ConfiguracionView()
                .tabItem {
                    Label("Configuración", systemImage: "gear")
                }.tag("3")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
