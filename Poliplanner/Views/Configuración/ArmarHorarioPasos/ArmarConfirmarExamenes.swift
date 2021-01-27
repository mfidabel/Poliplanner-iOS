//
//  ArmarConfirmarExamenes.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import SwiftUI

struct ArmarConfirmarExamenes: View {
    // MARK: Constantes
    
    /// Porcentaje de la pantalla atribuido al calendario
    let alturaCalendario: CGFloat = 0.40
    
    let alturaBarra: CGFloat = 0.05
    
    // MARK: Propiedades
    
    /// ViewModel de los pasos del armado del horario
    @EnvironmentObject private var viewModelPasos: ArmarHorarioPasosViewModel
    
    /// ViewModel de esta view
    @ObservedObject var viewModel: ConfirmarExamenesViewModel
    
    // MARK: Constructor
    
    init(secciones: [Seccion]) {
        self.viewModel = ConfirmarExamenesViewModel(secciones: secciones)
    }
    
    // MARK: Body
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                // BARRA DE SELECCIÓN DE MES
                generarBarraMes(proxy)
                Divider()
                // MES
                generarCalendario(proxy)
                Divider()
                // LISTA
                generarLista(proxy)
            }
        }
        .navigationBarTitle("Confirmar exámenes", displayMode: .inline)
        .navigationBarItems(leading: botonAtras, trailing: botonSiguiente)
    }
    
    /// View del botón para volver atrás
    var botonAtras: some View {
        Button("Atrás") {
            viewModelPasos.retroceder()
        }
    }
    
    /// View del botón para ir al siguiente paso
    var botonSiguiente: some View {
        Button("Siguiente") {
            viewModelPasos.avanzar()
        }
    }
    
    // MARK: Métodos
    
    func generarBarraMes(_ proxy: GeometryProxy) -> some View {
        let frameProxy = proxy.frame(in: .local)
        let altura = frameProxy.height * alturaBarra
        let anchura = frameProxy.width
        
        return
            HStack(alignment: .bottom) {
                Button {
                    viewModel.cargarMesAnterior()
                } label: {
                    Image(systemName: "chevron.left.circle")
                }
                
                Spacer()
                
                Text("\(viewModel.fecha.mesNombre) \(viewModel.fecha.añoNombre)")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    viewModel.cargarMesSiguiente()
                } label: {
                    Image(systemName: "chevron.right.circle")
                }
            }
            .padding([.top, .horizontal], 10.0)
            .frame(width: anchura, height: altura)
    }
    
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
            .frame(width: frameProxy.width, height: frameProxy.height * (1-alturaCalendario-alturaBarra))
    }
}

// struct ArmarConfirmarExamenes_Previews: PreviewProvider {
//    static var previews: some View {
//        ArmarConfirmarExamenes()
//    }
// }
