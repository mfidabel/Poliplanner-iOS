//
//  CVCalendar+Redraw.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-16.
//

import Foundation
import CVCalendar

// Permite que se redibuje cuando cambia el tamaño de la ventana
// https://github.com/CVCalendar/CVCalendar/issues/576#issuecomment-526569090
extension CVCalendarView {

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
    // Aparencia del dia actual
    static let fontDiaActual: UIFont? = .boldSystemFont(ofSize: 18.0)
    static let colorDiaActual: UIColor = .red
    
    // Aparencia de cualquier otro dia
    static let fontDiaNormal: UIFont? = UIFont(name: "Avenir", size: 18.0)
    static let colorDiaNormal: UIColor = .label
    
    // Aparencia de un dia de otro mes (day out)
    static let fontDiaFuera: UIFont? = UIFont(name: "Avenir", size: 18.0)
    static let colorDiaFuera: UIColor = .systemGray
    
    // MARK: VISTAS AUXILIARES
    static func diaActual(dayView: DayView) -> CVAuxiliaryView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: .circle)
        circleView.fillColor = .clear
        dayView.dayLabel.textColor = colorDiaActual
        dayView.dayLabel.font = fontDiaActual
        return circleView
    }
    
    static func diaNormal(dayView: DayView) -> CVAuxiliaryView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: .circle)
        circleView.fillColor = .clear
        if dayView.dayLabel != nil {
            dayView.dayLabel.textColor = colorDiaNormal
            dayView.dayLabel.font = fontDiaNormal
        }
        return circleView
    }
    
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
