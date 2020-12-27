//
//  CalendarioView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-08.
//

import SwiftUI

struct CalendarioView: View {
    @ObservedObject private var viewModel: CalendarioViewModel = CalendarioViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                // MES
                generarCalendario(proxy)
                Divider()
                generarLista(proxy)
            }
        }.navigationBarTitle(viewModel.tituloMes)
    }
    
    func generarCalendario(_ proxy: GeometryProxy) -> some View {
        let frameProxy = proxy.frame(in: .local)
        let altura = frameProxy.height * alturaCalendario
        let anchura = frameProxy.width
        return CalendarioMesView(viewModel: viewModel)
            .frame(width: anchura, height: altura)
    }
    
    func generarLista(_ proxy: GeometryProxy) -> some View {
        let frameProxy = proxy.frame(in: .local)
        return ListaEventosView(eventos: viewModel.eventosMes)
            .frame(width: frameProxy.width, height: frameProxy.height * (1-alturaCalendario))
    }
    
    // MARK: - Constantes
    // Porcentaje de la pantalla atribuido al calendario
    let alturaCalendario: CGFloat = 0.45
}

struct CalendarioView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                CalendarioView()
            }
        }
    }
}
