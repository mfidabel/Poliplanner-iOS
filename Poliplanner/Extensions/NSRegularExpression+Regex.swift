//
//  NSRegularExpression+Regex.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation
import Regex

extension NSRegularExpression {
    // MARK: Extra
    
    // https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
    /// Constructor unwrapped de una Expresión Regular.
    /// Se utiliza para no hacer un force unwrap de una expresión regular, pues podemos estar
    /// seguro de su validez en tiempo de compilación.
    /// - Parameter pattern: Patrón regular
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    /// Verifica si la expresión regular coincide con la cadena pasada como argumento
    /// - Parameter string: Cadena contra la que queremos probar la expresión regular
    /// - Returns: Verdadero si la expresión regular coincide, Falso caso contrario
    func matches(_ string: String) -> Bool {
            let range = NSRange(location: 0, length: string.utf16.count)
            return firstMatch(in: string, options: [], range: range) != nil
    }
    
    // MARK: Expresiones regulares
    
    /// Representa la hora en el formato HH:mm
    /// Ejemplo: 08:00, 18:00, 23:50
    static let horaComun = NSRegularExpression("^([0-1][0-9]|[2][0-3]):([0-5][0-9])$")
    
    /// Representa una asignatura con derecho a examen final
    /// Ejemplo: Investigación de Operaciones I (*)
    static let DEF = NSRegularExpression("\\(\\*\\)")
    
    /// Representa cadenas que poseen turno
    /// Ejemplo: MI, NA, TQ
    static let turno = NSRegularExpression("^[MTN]")
}

extension Regex {
    // MARK: Extra
    
    /// Constructor unwrapped de una Expresión Regular.
    /// Se utiliza para no hacer un force unwrap de una expresión regular, pues podemos estar
    /// seguro de su validez en tiempo de compilación.
    /// - Parameter pattern: Patrón regular
    convenience init(_ pattern: String, groupNames: [String]) {
        do {
            try self.init(pattern: pattern, groupNames: groupNames)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}
