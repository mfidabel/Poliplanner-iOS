//
//  NSRegularExpression+Regex.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-14.
//

import Foundation

extension NSRegularExpression {
    // https://www.hackingwithswift.com/articles/108/how-to-use-regular-expressions-in-swift
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
            let range = NSRange(location: 0, length: string.utf16.count)
            return firstMatch(in: string, options: [], range: range) != nil
    }
    
    /// Representa la hora en el formato HH:mm
    /// Ejemplo: 08:00, 18:00, 23:50
    static let horaComun = NSRegularExpression("^([0-1][0-9]|[2][0-3]):([0-5][0-9])$")
    
    static let DEF = NSRegularExpression("\\(\\*\\)")
    
    static let turno = NSRegularExpression("^[MTN]")
}
