//
//  Asignatura.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

/// Modelo que representa una asignatura como información.
/// Es decir, describe una asignatura independiente de la `Seccion`, horarios (`Clase`) y examenes (`Examen`).
class Asignatura: Object, Identifiable {
    // MARK: - Propiedades
    
    /// Identificador de la asignatura.
    @objc dynamic var id = UUID().uuidString
    
    /// Departamento al cual pertenece la asignatura. Ejemplo: "DIN" -> Departamento de Informática
    @objc dynamic var departamento: String = ""
    
    /// Nombre de la asignatura. Ejemplo: "Investigación de Operaciones I"
    @objc dynamic var nombre: String = ""
    
    /// Nivel de la asignatura. Ejemplo: "1"
    @objc dynamic var nivel: String = ""
    
    /// Semestre de la asignatura. Ejemplo: "3"
    @objc dynamic var semGrupo: String = ""

    /// Verifica si la asignatura es con "Derecho a examen final".
    /// Retorna True si lo es, False caso contrario.
    var esDEF: Bool {
        NSRegularExpression.DEF.matches(nombre)
    }
    
    /// Representación de la asignatura en `InfoAsignatura`
    var infoAsignatura: InfoAsignatura {
        InfoAsignatura(departamento: departamento,
                       nombre: nombre,
                       nivel: nivel,
                       semGrupo: semGrupo)
    }
    
    // MARK: - Métodos
    
    /// Función auxiliar que permite a `Realm` identificar las asignaturas por su id en la base de datos.
    override static func primaryKey() -> String? {
        return "id"
    }
}
