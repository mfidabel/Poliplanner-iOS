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
                    Image(systemName: "list.bullet")
                    Text("Clases")
                }.tag("0")
            Text("Tab Content 1")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendario")
                }
                .tag("1")
            Text("Tab Content 2")
                .tabItem {
                    Image(systemName: "rectangle.grid.1x2")
                    Text("Secciones")
                }
                .tag("2")
            ConfiguracionView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Configuración")
                }.tag("3")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PoliplannerStore(realm: RealmProvider.realm()))
    }
}
