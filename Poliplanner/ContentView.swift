//
//  ContentView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 11/25/20.
//

import SwiftUI
import StatefulTabView

/// Content view principal
struct ContentView: View {
    // MARK: Propiedades
    
    /// Indica que view esta seleccionada
    @State private var viewSeleccionada: ViewSeleccionada? = .horario

    // MARK: Body
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            tabViewPhone
        } else {
            // Los demás
            sidebar
        }
    }
    
    /// Vista desde celulares
    var tabViewPhone: some View {
        StatefulTabView {
            Tab(title: "Clases", systemImageName: "list.bullet") {
                HorarioClaseView()
            }
            
            Tab(title: "Calendario", systemImageName: "calendar") {
                NavigationView {
                    CalendarioView()
                }.navigationViewStyle(StackNavigationViewStyle())
            }
            
            Tab(title: "Secciones", systemImageName: "rectangle.grid.1x2") {
                NavigationView {
                    SeccionesView()
                }.navigationViewStyle(StackNavigationViewStyle())
            }
            
            Tab(title: "Configuración", systemImageName: "gear") {
                NavigationView {
                    ConfiguracionView()
                }.navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
    
    /// Vista desde tabletas
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
            .navigationBarTitle("PoliPlanner")
        }
    }
}

// MARK: - Preview

#if DEBUG
/// :nodoc:
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

// MARK: - Adicional

/// Enumerador que representa un view elegido en el TabView/Sidebar del contenido en el `ContentView`
private enum ViewSeleccionada {
    // MARK: Casos
    
    /// Vista del horario de clases
    case horario
    
    /// Vista del calendario de exámenes y revisiones
    case calendario
    
    /// Vista de las secciones elegidas con sus profesores
    case secciones
    
    /// Vista del menú de configuración
    case configuracion
}
