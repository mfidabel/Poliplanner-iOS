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

struct CalendarioMes: UIViewRepresentable {
    @ObservedObject var viewModel: CalendarioViewModel
    
    let frame: CGRect

    func makeUIView(context: Context) -> CVCalendarView {
        let view = CVCalendarView(frame: self.frame)
        view.calendarDelegate = context.coordinator
        view.commitCalendarViewUpdate()
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }
    
    func updateUIView(_ uiView: CVCalendarView, context: Context) {
        if !uiView.frame.equalTo(self.frame) {
            uiView.frame = self.frame
            uiView.bounds = self.frame
            uiView.redrawViewIfNecessary()
        }
    }
    
    func makeCoordinator() -> CalendarioViewModel {
        viewModel
    }
}
