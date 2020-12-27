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
    
    var tituloMes: String {
        "\(fecha.mesNombre) \(fecha.añoNombre)"
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
    // MARK: Configuraciones del calendario
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
        false
    }
    
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        false
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if let fechaConvertida = date.convertedDate() {
            self.fecha = fechaConvertida
        }
    }
    
    // MARK: Dia actual
    /// Retorna el view que corresponde a cierto día
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let view: CVAuxiliaryView
        
        // Verificamos que tipo de día es
        if dayView.isCurrentDay {
            view = .diaActual(dayView: dayView)
        } else if dayView.isOut {
            view = .diaFuera(dayView: dayView)
        } else {
            view = .diaNormal(dayView: dayView)
        }
        
        // Retornamos
        return view
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool { true }
    
    // MARK: Eventos
    /// Verifica si se deberia de mostrar el puntito debajo de un día (es decir, verifica si hay un evento)
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        if dayView.isOut || eventos.isEmpty {
            return false
        }
        
        if let fechaActual = dayView.date.convertedDate()?.base {
            return eventos.contains { $0.coincideCon(fecha: fechaActual) }
        }
        
        return false
    }
    
    /// Color del puntito debajo de un día con eventos
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        [.systemBlue]
    }
    
    /// Offset del puntito debajo de un día con eventos
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
        CGFloat(18)
    }
    
    /// Tamaño del puntito debajo de un día con eventos
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        CGFloat(16)
    }
}
