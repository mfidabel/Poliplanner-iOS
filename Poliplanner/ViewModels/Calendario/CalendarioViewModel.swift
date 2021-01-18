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

// MARK: - View Model del Calendario

/// View Model de la sección de Calendario.
/// Se encarga de administrar que eventos se muestran y manipular el mes seleccionado.
class CalendarioViewModel: ObservableObject {
    // MARK: Propiedades
    
    /// Eventos que se mostraran en el calendario
    @Published private(set) var eventos: [InfoEventoCalendario] = []
    
    /// Fecha actual del calendario, es igual a una fecha con el mes que se esta visualizando actualmente
    @Published private(set) var fecha: Date = Date()
    
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
    
    /// Título del mes que se mostrará al usuario
    var tituloMes: String {
        "\(fecha.mesNombre) \(fecha.añoNombre)"
    }
    
    /// Instancia de `Realm` para acceder a la base de datos
    private var realm: Realm = RealmProvider.realm()
    
    // MARK: Resultados
    
    /// Resultados con los exámenes de las materias elegidas
    private var examenesResult: RealmSwift.Results<Examen>
    
    // MARK: Tokens
    
    /// Token que se obtiene al subscribir a los resultados de los exámenes `CalendarioViewModel.examenesResult`
    private var examenesToken: NotificationToken?
    
    // MARK: Delegates
    
    weak var calendarioDelegate: CVCalendarView?
    
    // MARK: Métodos
    
    /// Genera los eventos que se cargarán al calendario a partir de los exámenes y sus revisiones correspondientes.
    private func generarEventos() {
        eventos = examenesResult.flatMap { examen in
            return examen.revision == nil
                ? [examen.eventoCalendario]
                : [examen.eventoCalendario, examen.revision!.eventoCalendario]
        }
    }
    
    /// Pasa al siguiente mes
    func cargarMesSiguiente() {
        calendarioDelegate?.loadNextView()
    }
    
    /// Pasa al mes anterior
    func cargarMesAnterior() {
        calendarioDelegate?.loadPreviousView()
    }
    
    // MARK: Constructor
    
    /// Constructor del View Model
    /// Se encarga de inicializar los resultados y generar los eventos iniciales.
    init() {
        // Inicializamos las variables
        examenesResult = realm.objects(Examen.self)
            .filter("ANY secciones.elegido == true")
            .filter("ANY secciones.horariosCarrera.horarioClase.estado == '\(EstadoHorario.ACTIVO.rawValue)'")
        generarEventos()
        // Empezamos a escuchar cambios
        examenesToken = examenesResult.observe { _ in
            self.generarEventos()
        }
    }
    
    // MARK: Deconstructor
    
    /// Limpieza de los tokens de notificación
    deinit {
        // Invalidamos el token
        examenesToken?.invalidate()
    }
}

// MARK: - CVCalendarViewDelegate
extension CalendarioViewModel: CVCalendarViewDelegate {
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
