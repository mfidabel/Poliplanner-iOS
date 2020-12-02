//
//  UTType+Excel.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-12-02.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    static var xlsx: UTType {
        UTType.types(tag: "xlsx", tagClass: .filenameExtension, conformingTo: nil).first!
    }
    
    static var xls: UTType {
        UTType.types(tag: "xls", tagClass: .filenameExtension, conformingTo: nil).first!
    }
}
