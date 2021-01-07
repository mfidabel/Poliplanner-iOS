//
//  Clase.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-26.
//

import Foundation
import RealmSwift

/// Modelo que representa una clase de una sección en la semana
class Clase: Object, Identifiable {
    // MARK: - Propiedades
    
    /// Identificador de la clase
    @objc dynamic var id = UUID().uuidString
    
    /// Día de la clase. Tratar no editar directamente y utilizar `Clase.diaEnum` como sustituto
    @objc dynamic var dia: String = DiaClase.LUNES.rawValue
    
    /// Hora de inicio de la clase
    @objc dynamic var horaInicio: String = ""
    
    /// Hora de fin de la clase
    @objc dynamic var horaFin: String = ""
    
    /// Aula donde será la clase
    @objc dynamic var aula: String = ""
    
    /// Puente entre el enumerador `DiaClase` y el día de la clase
    var diaEnum: DiaClase {
        get {
            return DiaClase(rawValue: dia)!
        }
        
        set {
            dia = newValue.rawValue
        }
    }

    // MARK: - Métodos
    
    /// Función auxiliar que permite a `Realm` identificar las clases por su id en la base de datos.
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /// Setea la hora de la clase
    func setHora(_ hora: String) {
        // TODO: Parsear correctamente la hora
        self.horaInicio = hora
        self.horaFin = hora
    }
}
