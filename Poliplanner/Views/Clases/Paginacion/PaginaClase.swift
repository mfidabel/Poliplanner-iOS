//
//  PaginaClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
//

import SwiftUI

// MARK: - Página de clases

/// View de una página con la listas de clases de cierto día
struct PaginaClase: View {
    // MARK: Propiedades
    
    /// Información de la página
    let pagina: InfoPaginaDia
    
    // MARK: Body
    
    var body: some View {
        List {
            ForEach(pagina.clases, id: \.self) { clase in
                ClaseCelda(clase: clase)
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
            HStack {
                Text(clase.hora)
                Spacer()
                Text(clase.aula)
            }.padding(.top, 1.0)
        }.padding(.vertical, 5)
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
        clase.horaInicio = "18:00 - 19:00"
        return InfoClase(asignatura: "Investigación de Operaciones",
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
