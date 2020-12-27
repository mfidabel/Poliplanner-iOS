//
//  CalendarioMesView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-15.
//

import SwiftUI

struct CalendarioMesView: View {
    @ObservedObject var viewModel: CalendarioViewModel
    
    var body: some View {
        GeometryReader { proxy in
           generarViews(proxy)
        }
    }
    
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
            CalendarioMes(viewModel: viewModel, frame: frameMes)
                .frame(width: frameMes.width, height: frameMes.height)
        }
    }
    
    let alturaMenu: CGFloat = 30
    let espacioMenuMes: CGFloat = 0
}

struct CalendarioMesView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarioMesView(viewModel: CalendarioViewModel())
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
