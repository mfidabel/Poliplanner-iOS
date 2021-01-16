//
//  HorarioClaseView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-01.
//

import SwiftUI

// MARK: Sección de Horarios de Clase

/// View Principal donde se ven las clases por cada día en páginas
struct HorarioClaseView: View {
    // MARK: Propiedades
    
    /// View Model que controla este View
    @ObservedObject private var HCViewModel = HorarioClaseViewModel()
    
    /// Identifica si es un celular o una tableta
    let esCelular: Bool = UIDevice.current.userInterfaceIdiom == .phone

    // MARK: Body
    
    var body: some View {
        ZStack {
            // Color fondo
            R.color.backgroundClaseMenu.color
                .edgesIgnoringSafeArea(.top)
            
            // Contenido
            VStack(alignment: .leading) {
                if esCelular {
                    Text("PoliPlanner")
                        .font(.system(size: 34.0))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading, 20.0)
                    
                    Spacer()
                        .frame(height: 5.0)
                }
                // Paginas de materias
                PaginacionMateriaView(paginas: HCViewModel.clasesPorDia)
            }
        }.navigationBarTitle("", displayMode: .inline)
    }
}
