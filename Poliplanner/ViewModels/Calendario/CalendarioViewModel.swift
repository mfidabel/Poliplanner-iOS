//
//  CalendarioViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation
import RealmSwift
import SwiftUI
import CVCalendar

class CalendarioViewModel: ObservableObject {
    // MARK: - Variables
    @Published private(set) var eventos: [InfoEventoCalendario] = []
    @Published private(set) var fecha: Date = Date()
    var eventosMes: [InfoEventoCalendario] {
        eventos.filter { evento in
            return Calendar.current.isDate(fecha, equalTo: evento.fecha, toGranularity: .month)
        }
    }
    
    // MARK: - Resultados
    private var examenesResult: RealmSwift.Results<Examen>
    
    // MARK: - Tokens
    private var examenesToken: NotificationToken?
    
    // MARK: - Realm
    private var realm: Realm = RealmProvider.realm()
    
    // MARK: - Funciones
    private func generarEventos() {
        eventos = examenesResult.map { $0.eventoCalendario }
    }
    
    // MARK: - Inicializador
    init() {
        // Inicializamos las variables
        examenesResult = realm.objects(Examen.self)
            .filter("ANY secciones.elegido == true")
        generarEventos()
        // Empezamos a escuchar cambios
        examenesToken = examenesResult.observe { _ in
            self.generarEventos()
        }
    }
    
    // MARK: - Desinicializador
    deinit {
        // Invalidamos el token
        examenesToken?.invalidate()
    }
}

// MARK: - CVCalendarViewDelegate
extension CalendarioViewModel: CVCalendarViewDelegate {
    func presentationMode() -> CalendarMode {
        .monthView
    }
    
    func firstWeekday() -> Weekday {
        .sunday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        true
    }
    
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        false
    }
    
    func shouldScrollOnOutDayViewSelection() -> Bool {
        true
    }
    
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        true
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if let fechaConvertida = date.convertedDate() {
            self.fecha = fechaConvertida
        }
    }
}
