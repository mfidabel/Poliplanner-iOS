//
//  CVCalendar+Redraw.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-16.
//

import Foundation
import CVCalendar

extension CVCalendarView {
    // MARK: - Redraw
    
    /// Permite que se redibuje cuando cambia el tamaño de la ventana
    /// https://github.com/CVCalendar/CVCalendar/issues/576#issuecomment-526569090
    public func redrawViewIfNecessary() {
        let contentViewSize = contentController.bounds.size
        let selfSize = bounds.size
        let screenSize = UIScreen.main.bounds.size
        let allowed = selfSize.width <= screenSize.width && selfSize.height <= screenSize.height
        setNeedsLayout()
        layoutIfNeeded()
        if !allowed {
            return
        }
        let width = selfSize.width
        let height: CGFloat
        let countOfWeeks = CGFloat(6)
        guard let mode = calendarMode,
            let vSpace = appearance.spaceBetweenWeekViews,
            let hSpace = appearance.spaceBetweenDayViews else {
            return
        }
        switch mode {
        case .weekView:
            height = selfSize.height
        case .monthView:
            height = (selfSize.height / countOfWeeks) - (vSpace * countOfWeeks)
        }
        
        let found = constraints.contains { constraint in
            constraint.firstAttribute == .height
        }
        
        if !found {
            addConstraint(NSLayoutConstraint(item: self,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .height,
                                             multiplier: 1,
                                             constant: frame.height))
        }
        weekViewSize = CGSize(width: width, height: height)
        dayViewSize = CGSize(width: (width / 7.0) - hSpace, height: height)
        contentController.refreshPresentedMonth()
        contentController.updateFrames(selfSize != contentViewSize ? bounds : CGRect.zero)
    }
}

// MARK: - CVAuxiliaryView + Casos
extension CVAuxiliaryView {
    // MARK: - Constantes de fuentes y colores
    
    // Aparencia del dia actual
    
    /// Fuente del día actual en el calendario
    static let fontDiaActual: UIFont? = .boldSystemFont(ofSize: 18.0)
    
    /// Color del día actual en el calendario
    static let colorDiaActual: UIColor = .red
    
    // Aparencia de cualquier otro dia
    
    /// Fuente de cualquier día en el calendario
    static let fontDiaNormal: UIFont? = UIFont(name: "Avenir", size: 18.0)
    
    /// Color de cualquier día en el calendario
    static let colorDiaNormal: UIColor = .label
    
    // Aparencia de un dia de otro mes (day out)
    
    /// Fuente de un día de otro mes
    static let fontDiaFuera: UIFont? = UIFont(name: "Avenir", size: 18.0)
    
    /// Color de un día de otro mes
    static let colorDiaFuera: UIColor = .systemGray
    
    // MARK: VISTAS AUXILIARES
    
    /// Genera un view basado en el día actual
    /// - Parameter dayView: `DayView` para la cual estamos construyendo el View
    /// - Returns: El View que se mostrará en el calendario
    static func diaActual(dayView: DayView) -> CVAuxiliaryView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: .circle)
        circleView.fillColor = .clear
        dayView.dayLabel.textColor = colorDiaActual
        dayView.dayLabel.font = fontDiaActual
        return circleView
    }
    
    /// Genera un view basado en un día normal
    /// - Parameter dayView: `DayView` para la cual estamos construyendo el View
    /// - Returns: El View que se mostrará en el calendario
    static func diaNormal(dayView: DayView) -> CVAuxiliaryView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: .circle)
        circleView.fillColor = .clear
        if dayView.dayLabel != nil {
            dayView.dayLabel.textColor = colorDiaNormal
            dayView.dayLabel.font = fontDiaNormal
        }
        return circleView
    }
    
    /// Genera un view basado en un día de otro mes
    /// - Parameter dayView: `DayView` para la cual estamos construyendo el View
    /// - Returns: El View que se mostrará en el calendario
    static func diaFuera(dayView: DayView) -> CVAuxiliaryView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: .circle)
        circleView.fillColor = .clear
        if dayView.dayLabel != nil {
            dayView.dayLabel.textColor = colorDiaFuera
            dayView.dayLabel.font = fontDiaFuera
        }
        return circleView
    }
}
