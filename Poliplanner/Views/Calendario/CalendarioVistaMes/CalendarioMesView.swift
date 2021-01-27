//
//  CalendarioMesView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-15.
//

import SwiftUI

// MARK: - Calendario Mes

/// View que muestra el calendario por mes
struct CalendarioMesView: View {
    // MARK: Propiedades
    
    /// View Model que controlará este view
    var viewModel: CVCalendarioViewModel
    
    // MARK: Body
    
    var body: some View {
        GeometryReader { proxy in
           generarViews(proxy)
        }
    }
    
    // MARK: Métodos
    
    /// Genera los views del mes y los días en base al espacio proporcionado
    /// - Parameter proxy: Geometria del View
    /// - Returns: La vistas con los tamaños correctos
    func generarViews(_ proxy: GeometryProxy) -> some View {
        let frameProxy = proxy.frame(in: .local)
        let frameMenu = CGRect(x: 0, y: 0,
                               width: frameProxy.width,
                               height: alturaMenu)
        let frameMes = CGRect(x: 0, y: 0,
                              width: frameProxy.width,
                              height: frameProxy.height - alturaMenu - espacioMenuMes)
        return VStack {
            CalendarioMenuView(frame: frameMenu)
                .frame(width: frameMenu.width, height: frameMenu.height)
            CalendarioMes(viewModel: viewModel, frame: frameMes, fecha: viewModel.fecha)
                .frame(width: frameMes.width, height: frameMes.height)
        }
    }
    
    // MARK: Constantes de estilo
    
    /// Altura de la sección de los días (La parte de arriba del calendario)
    let alturaMenu: CGFloat = 30
    
    /// Espacio entre la parte de arriba del calendario y el mes
    let espacioMenuMes: CGFloat = 0
}

// MARK: - Preview

#if DEBUG
/// :nodoc:
struct CalendarioMesView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarioMesView(viewModel: CalendarioViewModel())
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
#endif
