//
//  CalendarioMenuView.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-16.
//

import Foundation
import SwiftUI
import UIKit
import CVCalendar

// MARK: Calendario Menu

/// View que muestra los días de la semana del calendario.
/// Hace de puente a `CVCalendarMenuView` hacia SwiftUI
struct CalendarioMenuView: UIViewRepresentable {
    // MARK: UIKit
    
    /// UIView que representa este SwiftUI View
    typealias UIViewType = CVCalendarMenuView

    // MARK: Propiedades
    
    /// Frame que utilizará el menu para dibujar
    let frame: CGRect
    
    // MARK: Protocolo UIViewRepresentable
    
    /// Crea el `CVCalendarMenuView` con su delegate
    func makeUIView(context: Context) -> CVCalendarMenuView {
        let view = CVCalendarMenuView(frame: self.frame)
        view.commitMenuViewUpdate()
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.calendar = .calendarioReferencia
        view.delegate = context.coordinator
        return view
    }
    
    /// Actualiza el view a los nuevos tamaños del frame
    func updateUIView(_ uiView: CVCalendarMenuView, context: Context) {
        uiView.frame = self.frame
        uiView.commitMenuViewUpdate()
    }
    
    /// Crea el coordinador que se usará como delegate
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: Delegate
    
    /// Sirve como `CVCalendarMenuViewDelegate` para el view del menu del calendario
    class Coordinator: NSObject, CVCalendarMenuViewDelegate {
        
        /// Selecciona el color del texto que se usará en los días de la semana
        func dayOfWeekTextColor() -> UIColor {
            .label
        }
        
    }
}
