//
//  CalendarioMes.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-15.
//  Basado en https://stackoverflow.com/a/61857102/12657639

import Foundation
import SwiftUI
import UIKit
import CVCalendar

/// View del calendario solo mostrando los números del mes.
/// Representa `CVCalendarView` como un SwiftUI View
struct CalendarioMes: UIViewRepresentable {
    // MARK: Propiedades
    
    /// View Model que controla el calendario, se utilizará como delegate del `CVCalendarView`
    let viewModel: CVCalendarioViewModel
    
    /// Frame que utilizará el calendario. Es necesario para calcular las dimensiones del calendario
    let frame: CGRect
    
    /// Fecha que se debe mostrar
    let fecha: Date

    // MARK: Protocolo UIViewRepresentable
    
    /// Crea el UIView del calendario y asigna su delegate
    func makeUIView(context: Context) -> CVCalendarView {
        let view = CVCalendarView(frame: self.frame)
        view.calendarDelegate = context.coordinator
        view.commitCalendarViewUpdate()
        view.setContentHuggingPriority(.required, for: .horizontal)
        viewModel.calendarioDelegate = view
        return view
    }
    
    /// Actualiza el UIView cuando cambia algo
    func updateUIView(_ uiView: CVCalendarView, context: Context) {
        // Actualiza el dibujo de ser necesario
        if !uiView.frame.equalTo(self.frame) {
            uiView.frame = self.frame
            uiView.bounds = self.frame
            uiView.redrawViewIfNecessary()
        }
        
        // Actualizamos el calendario por si falta
        if context.coordinator.calendarioDelegate == nil {
            context.coordinator.calendarioDelegate = uiView
        }
    }
    
    /// Crea el coordinador, que seria el view model que se pasó
    func makeCoordinator() -> CVCalendarioViewModel {
        viewModel
    }
    
    /// Limpia el view y deshace el delegate del view model
    static func dismantleUIView(_ uiView: CVCalendarView, coordinator: CVCalendarioViewModel) {
        coordinator.calendarioDelegate = nil
    }
}
