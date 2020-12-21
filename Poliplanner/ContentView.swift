//
//  ContentView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 11/25/20.
//

import SwiftUI

struct ContentView: View {
    // Setear el sidebar para que muestre primero el horario
    @State private var viewSeleccionada: ViewSeleccionada? = .horario

    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            tabViewPhone
        } else {
            // Los demás
            sidebar
        }
    }
    
    var tabViewPhone: some View {
        TabView {
            // Horario de clases
            HorarioClaseView()
                .tabItem {
                    Label("Clases", systemImage: "list.bullet")
                }.tag(ViewSeleccionada.horario)
            // Calendario de examenes
            NavigationView {
                CalendarioView()
            }
                .tabItem {
                    Label("Calendario", systemImage: "calendar")
                }
                .tag(ViewSeleccionada.calendario)
            // Secciones
            NavigationView {
                SeccionesView()
            }
                .tabItem {
                    Label("Secciones", systemImage: "rectangle.grid.1x2")
                }
            .tag(ViewSeleccionada.secciones)
            // Configuración
            NavigationView {
                ConfiguracionView()
            }
                .tabItem {
                    Label("Configuración", systemImage: "gear")
                }.tag(ViewSeleccionada.configuracion)
        }
    }
    
    var sidebar: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(
                        destination: HorarioClaseView(),
                        tag: .horario,
                        selection: $viewSeleccionada) {
                        Label("Clases", systemImage: "list.bullet")
                    }
                    NavigationLink(
                        destination: CalendarioView(),
                        tag: .calendario,
                        selection: $viewSeleccionada) {
                        Label("Calendario", systemImage: "calendar")
                    }
                    NavigationLink(
                        destination: SeccionesView(),
                        tag: .secciones,
                        selection: $viewSeleccionada) {
                        Label("Secciones", systemImage: "rectangle.grid.1x2")
                    }
                }
                
                Section {
                    NavigationLink(
                        destination: ConfiguracionView(),
                        tag: .configuracion,
                        selection: $viewSeleccionada) {
                        Label("Configuración", systemImage: "gear")
                    }
                }
            }
            .navigationBarTitle(Text("Poliplanner"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Enumerador que representa un view elegido en el TabView/Sidebar del contenido
private enum ViewSeleccionada {
    case horario
    case calendario
    case secciones
    case configuracion
}
