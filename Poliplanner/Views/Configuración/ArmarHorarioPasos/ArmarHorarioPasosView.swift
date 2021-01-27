//
//  ArmarHorarioPasosView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-23.
//

import SwiftUI

struct ArmarHorarioPasosView: View {
    // MARK: Propiedades
    
    @ObservedObject var viewModel: ArmarHorarioPasosViewModel
    
    init(estaPresentando: Binding<Bool>) {
        viewModel = ArmarHorarioPasosViewModel(estaPresentando: estaPresentando)
    }
    
    // MARK: Body
    
    var body: some View {
        Group {
            switch viewModel.pasoActual {
            case .seleccionCarreras:
                ArmarSeleccionarCarrera()
            case .seleccionMaterias(let carrera):
                ArmarSeleccionarMaterias(carrera: carrera,
                                         selecciones: viewModel.materiasSeleccionadas[carrera])
            case .seleccionSecciones:
                ArmarSeleccionarSecciones(materiasSeleccionadas: viewModel.materiasSeleccionadas)
            case .confirmacionClases:
                ArmarConfirmarClases(secciones: Array(viewModel.seccionesSeleccionadas))
            case .confirmacionExamenes:
                ArmarConfirmarExamenes(secciones: Array(viewModel.seccionesSeleccionadas))
            case .fin:
                ArmarConfirmarHorario()
            }
        }.environmentObject(viewModel)
    }
}

#if DEBUG
/// :nodoc:
struct ArmarHorarioPasosView_Previews: PreviewProvider {
    static var previews: some View {
        ArmarHorarioPasosView(estaPresentando: .constant(true))
    }
}
#endif
