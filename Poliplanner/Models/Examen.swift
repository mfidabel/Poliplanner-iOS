//
//  Examen.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

class Examen: Object, Identifiable, Calendarizable {
    // swiftlint:disable identifier_name
    @objc dynamic var id = UUID().uuidString
    // swiftlint:enable identifier_name
    @objc dynamic var tipo: String = TipoExamen.evaluacion.rawValue
    @objc dynamic var fecha: Date = Date()
    @objc dynamic var aula: String = ""
    @objc dynamic var revision: Revision?
    let secciones = LinkingObjects(fromType: Seccion.self, property: "examenes")
    
    var seccion: Seccion {
        secciones.first!
    }
    
    // Puente entre enumerador de tipo de examen a atributo
    var tipoEnum: TipoExamen {
        get {
            return TipoExamen(rawValue: tipo)!
        }
        set {
            tipo = newValue.rawValue
        }
    }
    
    // MARK: - Valores de la fecha
    private var dateComponents: DateComponents {
        Calendar.autoupdatingCurrent.dateComponents(
            [.calendar, .timeZone, .day, .month, .year, .hour, .minute],
            from: fecha)
    }
    
    // swiftlint:disable large_tuple
    var fechaComponentes: (dia: Int, mes: Int, anho: Int) {
        let componentes = self.dateComponents
        return (dia: componentes.day!, mes: componentes.month!, anho: componentes.year!)
    }
    
    var horaComponentes: (hora: Int, minuto: Int)? {
        let componentes = self.dateComponents
        if componentes.hour != nil, componentes.minute != nil {
            return (hora: componentes.hour!, minuto: componentes.minute!)
        }
        return nil
    }
    // swiftlint:enable large_tuple

    // MARK: - Calendario
    var eventoCalendario: InfoEventoCalendario {
        InfoEventoCalendario(fecha: fecha,
                             titulo: tipoEnum.nombreLindo(),
                             descripcion: seccion.asignatura!.nombre,
                             aula: aula)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
