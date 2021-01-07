//
//  Calendarizable.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation

/// Permite calendarizar como evento en el calendario de la sección "Calendario".
protocol Calendarizable {
    // MARK: - Propiedades
    
    /// Propiedad que representa el evento como un `InfoEventoCalendario` para utilizar en el calendario.
    var eventoCalendario: InfoEventoCalendario { get }
}
