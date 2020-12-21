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

struct CalendarioMenuView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    let frame: CGRect
    
    func makeUIView(context: Context) -> CVCalendarMenuView {
        let view = CVCalendarMenuView(frame: self.frame)
        view.commitMenuViewUpdate()
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: CVCalendarMenuView, context: Context) {
        uiView.frame = self.frame
        uiView.commitMenuViewUpdate()
    }
    
    typealias UIViewType = CVCalendarMenuView
    
    class Coordinator: NSObject, CVCalendarMenuViewDelegate {
        
        func dayOfWeekTextColor() -> UIColor {
            .label
        }
        
    }
}
