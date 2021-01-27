//
//  ConfirmarExamenesViewModel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-26.
//

import Foundation
import CVCalendar

// MARK: - Confirmar Examenes View Model
class ConfirmarExamenesViewModel: ObservableObject, CVCalendarioViewModel {
    // MARK: Propiedades
    
    /// Eventos que se mostraran en el calendario
    @Published private(set) var eventos: [InfoEventoCalendario] = []
    
    /// Fecha actual del calendario, es igual a una fecha con el mes que se esta visualizando actualmente
    @Published private(set) var fecha: Date = Date()
    
    // MARK: Delegates
    
    /// Delegate del calendario
    weak var calendarioDelegate: CVCalendarView?
    
    // MARK: Constructor
    
    init(secciones: [Seccion]) {
        self.eventos = secciones.flatMap { seccion -> [InfoEventoCalendario] in
            let eventos: [InfoEventoCalendario] = seccion.examenes.flatMap { examen in
                examen.revision == nil
                    ? [examen.eventoCalendario]
                    : [examen.eventoCalendario, examen.revision!.eventoCalendario]
            }
                
            return eventos.map { original in
                var nuevo = original
                nuevo.descripcion = seccion.asignatura!.nombre
                return nuevo
            }
        }
    }
}

// MARK: - CVCalendarViewDelegate
extension ConfirmarExamenesViewModel: CVCalendarViewDelegate {
    // MARK: Configuraciones del calendario
    
    /// Modo de presentación del calendario
    func presentationMode() -> CalendarMode {
        .monthView
    }
    
    /// Primer día de la semana
    func firstWeekday() -> Weekday {
        .sunday
    }
    
    /// Si se debería de mostrar los días de otro mes distinto al que se esta mostrando
    func shouldShowWeekdaysOut() -> Bool {
        true
    }
    
    /// Si se debería autoseleccionar el día cuando cambie de semana
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        false
    }
    
    /// Si se debería de cambiar de mes cuando se selecciona un día de otro mes distinto al que se esta mostrando
    func shouldScrollOnOutDayViewSelection() -> Bool {
        false
    }
    
    /// Si se debería de seleccionar algún día
    func shouldSelectDayView(_ dayView: DayView) -> Bool {
        false
    }
    
    /// Si se debería de auto seleccionar un día cuando se cambie de mes
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        false
    }
    
    /// Qué hacer cuando se cambia de fecha. En este caso procedemos a guardar la fecha nueva
    func presentedDateUpdated(_ date: CVDate) {
        if let fechaConvertida = date.convertedDate() {
            self.fecha = fechaConvertida
        }
    }
    
    // MARK: Día actual
    
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
    
    /// Si es que se debería de mostrar el view preliminar en los días
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
