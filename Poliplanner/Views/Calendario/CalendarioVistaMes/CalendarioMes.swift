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
    @ObservedObject var viewModel: CalendarioViewModel
    
    /// Frame que utilizará el calendario. Es necesario para calcular las dimensiones del calendario
    let frame: CGRect

    // MARK: Protocolo UIViewRepresentable
    
    /// Crea el UIView del calendario y asigna su delegate
    func makeUIView(context: Context) -> CVCalendarView {
        let view = CVCalendarView(frame: self.frame)
        view.calendarDelegate = context.coordinator
        view.commitCalendarViewUpdate()
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }
    
    /// Actualiza el UIView cuando cambia algo (frame o fecha)
    func updateUIView(_ uiView: CVCalendarView, context: Context) {
        if !uiView.frame.equalTo(self.frame) {
            uiView.frame = self.frame
            uiView.bounds = self.frame
            uiView.redrawViewIfNecessary()
        }
    }
    
    /// Crea el coordinador, que seria el view model que se pasó
    func makeCoordinator() -> CalendarioViewModel {
        viewModel
    }
}
