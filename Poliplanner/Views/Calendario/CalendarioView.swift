//
//  CalendarioView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-08.
//

import SwiftUI

// MARK: - Calendario

/// View principal de la sección de Calendario
struct CalendarioView: View {
    // MARK: Propiedades
    
    /// View Model que controla este View
    @ObservedObject private var viewModel: CalendarioViewModel = CalendarioViewModel()
    
    // MARK: Body
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                // MES
                generarCalendario(proxy)
                Divider()
                generarLista(proxy)
            }
        }.navigationBarTitle(viewModel.tituloMes, displayMode: .inline)
        .navigationBarItems(leading: botonAtras, trailing: botonDelante)
    }
    
    /// Botón izquierdo que manda el mes para atrás
    var botonAtras: some View {
        Button(action: {
            viewModel.cargarMesAnterior()
        }, label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Anterior")
            }
        })
    }
    
    /// Botón derecho que manda el mes para adelante
    var botonDelante: some View {
        Button(action: {
            viewModel.cargarMesSiguiente()
        }, label: {
            HStack {
                Text("Siguiente")
                Image(systemName: "chevron.forward")
            }
        })
    }
    
    // MARK: Métodos
    
    /// Genera el view que correspondiente al calendario
    /// - Parameter proxy: `GeometryProxy` que vendrá del contenedor del View
    /// - Returns: El view con el calendario
    func generarCalendario(_ proxy: GeometryProxy) -> some View {
        let frameProxy = proxy.frame(in: .local)
        let altura = frameProxy.height * alturaCalendario
        let anchura = frameProxy.width
        return CalendarioMesView(viewModel: viewModel)
            .frame(width: anchura, height: altura)
    }
    
    /// Genera el view correspondiente a la lista de eventos
    /// - Parameter proxy: `GeometryProxy` que vendra del contenedor del Voew
    /// - Returns: El View con la lista de eventos
    func generarLista(_ proxy: GeometryProxy) -> some View {
        let frameProxy = proxy.frame(in: .local)
        return ListaEventosView(eventos: viewModel.eventosMes)
            .frame(width: frameProxy.width, height: frameProxy.height * (1-alturaCalendario))
    }
    
    // MARK: Constantes
    
    /// Porcentaje de la pantalla atribuido al calendario
    let alturaCalendario: CGFloat = 0.45
}

// MARK: - Preview

#if DEBUG
/// :nodoc:
struct CalendarioView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                CalendarioView()
            }
        }
    }
}
#endif
