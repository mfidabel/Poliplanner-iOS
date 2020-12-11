//
//  PaginaClase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-09.
//

import SwiftUI

struct PaginaClase: View {
    let pagina: InfoPaginaDia
    
    var body: some View {
        List {
            ForEach(pagina.clases, id: \.self) { clase in
                ClaseCelda(clase: clase)
            }
        }
    }
}

struct ClaseCelda: View {
    let clase: InfoClase
    
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

#if DEBUG
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
