//
//  CVCalendarioViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-26.
//

import Foundation
import CVCalendar

protocol CVCalendarioViewModel: CVCalendarViewDelegate {
    
    /// Eventos que se mostraran en el calendario
    var eventos: [InfoEventoCalendario] { get }
    
    /// Fecha actual del calendario, es igual a una fecha con el mes que se esta visualizando actualmente
    var fecha: Date { get }
    
    /// Calendario que será manipulado
    var calendarioDelegate: CVCalendarView? { get set }
    
}

extension CVCalendarioViewModel {
    // MARK: Propiedades extra
    
    /// Eventos que se mostraran en el calendario en base al mes que indica la fecha.
    /// Ejemplo: Si el mes es Abril, se muestran los eventos que suceden en abril.
    var eventosMes: [InfoEventoCalendario] {
        eventos.filter { evento in
            return Calendar.current.isDate(fecha, equalTo: evento.fecha, toGranularity: .month)
        }
        .sorted { (lhs, rhs) -> Bool in
            lhs.fecha < rhs.fecha
        }
    }
    
    // MARK: API Extra
    
    /// Pasa al siguiente mes
    func cargarMesSiguiente() {
        calendarioDelegate?.loadNextView()
    }
    
    /// Pasa al mes anterior
    func cargarMesAnterior() {
        calendarioDelegate?.loadPreviousView()
    }
    
}
