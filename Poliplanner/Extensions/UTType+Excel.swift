//
//  UTType+Excel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    // MARK: - Archivos de horarios de clase parseables
    
    /// Archivos de tipo excel en versiones posteriores o iguales a Excel 2007 (12.0)
    static var xlsx: UTType {
        UTType.types(tag: "xlsx", tagClass: .filenameExtension, conformingTo: nil).first!
    }
    
    /// Archivos de tipo excel en versiones anteriores o iguales a Excel 2003 (11.0)
    static var xls: UTType {
        UTType.types(tag: "xls", tagClass: .filenameExtension, conformingTo: nil).first!
    }
}
