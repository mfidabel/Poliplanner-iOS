//
//  InfoEventoCalendario.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation

/// Estructura que representa una entrada en el calendario de la sección Calendario
struct InfoEventoCalendario: Hashable {
    // MARK: Propiedades
    
    /// Fecha del evento
    var fecha: Date
    
    /// Título a mostrar del evento
    var titulo: String
    
    /// Descripción a mostrar del evento
    var descripcion: String
    
    /// En que aula se desarrollará el evento
    var aula: String = ""
    
    /// Hora del evento que se mostrará en los views
    /// Muestra la hora del evento en hh:MM pero si el evento es a media noche se considera todo el día
    var hora: String {
        esTodoElDia
            ? ""
            : fecha.horaNombre
    }
    
    /// Indica si el evento es todo el día
    var esTodoElDia: Bool {
        fecha.horaNombre == "00:00"
    }
}

// MARK: - API

extension InfoEventoCalendario {
    
    /// Verifica si este evento se da en la fecha actual
    /// - Returns: Verdadero si es que coincide con la fecha actual, falso caso contrario
    var esHoy: Bool {
        Calendar.current.isDate(fecha, inSameDayAs: Date())
    }
    
    /// Verifica si este evento coincide con la fecha pasada como argumento
    /// - Parameter conFecha: Fecha contra la cual se quiere saber si coincide
    /// - Returns: Verdadero si es que coincide con la fecha pasada como argumento, falso caso contrario
    func coincideCon(fecha conFecha: Date) -> Bool {
        Calendar.current.isDate(conFecha, inSameDayAs: self.fecha)
    }
}
