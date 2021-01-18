//
//  PaginaClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
//

import SwiftUI
import Rswift

// MARK: - Página de clases

/// View de una página con la listas de clases de cierto día
struct PaginaClase: View {
    // MARK: Propiedades
    
    /// Información de la página
    let pagina: InfoPaginaDia
    
    // MARK: Body
    
    var body: some View {
        ZStack {
            // Color de fondo
            R.color.backgroundClaseLista.color
            
            // Contenido
            if pagina.clases.isEmpty {
                Text("No tienes clases este día")
            } else {
                ScrollView {
                    Spacer()
                        .frame(height: 12.0)
                    ForEach(pagina.clases, id: \.self) { clase in
                        ClaseCelda(clase: clase)
                            .padding(.trailing, 10.0)
                        Divider()
                    }
                    .padding(.leading, 20.0)
                }
            }
        }
    }
}

// MARK: - Celda de clase

/// View que representa una clase dentro de la lista de clases de una página
struct ClaseCelda: View {
    // MARK: Propiedades
    
    /// Información sobre la clase a mostrar en el View
    let clase: InfoClase
    
    // MARK: Body
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(clase.asignatura)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(R.color.nombreAsignaturaClase.color)
            HStack {
                Text(clase.hora)
                Spacer()
                Text(clase.aula)
            }.padding(.top, 1.0)
        }
        .listRowBackground(Color.clear)
    }
}

// MARK: - Preview

#if DEBUG
/// :nodoc:
struct ClaseCeldaPreviews: PreviewProvider {
    static let infoClase: InfoClase = {
        let clase = Clase()
        clase.aula = "A01"
        clase.dia = DiaClase.LUNES.rawValue
        clase.horaInicio = "18:00"
        clase.horaFin = "19:00"
        return InfoClase(asignatura: "Optativa 3 - Metodología de la investigación",
                         clase: clase)
    }()
       
    static var previews: some View {
        Group {
            ClaseCelda(clase: infoClase)
                .frame(width: 375, height: 80, alignment: .leading)
                .padding(.horizontal, 10)
            
            ClaseCelda(clase: infoClase)
                .frame(width: 375, height: 80, alignment: .leading)
                .padding(.horizontal, 10)
                .environment(\.colorScheme, .dark)
                .background(Color(.black))
            
            // 320 pixeles de ancho, producto más fino
            ClaseCelda(clase: infoClase)
                .frame(width: 320, height: 80, alignment: .leading)
                .padding(.horizontal, 10)
        }
        .previewLayout(.sizeThatFits)
        
    }
}
#endif
