//
//  RealmProvider.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-30.
//

import Foundation
import RealmSwift

/// Proveedor de la base de datos de Realm
class RealmProvider {
    // MARK: - Métodos
    
    /// Retorna una instancia de `Realm` para el hilo.
    /// - Returns: Realm
    class func realm() -> Realm {
        var realm: Realm
        do {
            if NSClassFromString("XCTest") != nil {
                realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
            } else {
                #if DEBUG
                print("Realm database: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
                #endif
                realm = try Realm()
            }
        } catch let error as NSError {
            fatalError("Error al abrir el realm. Error: \(error.localizedDescription)")
        }
        return realm
    }
}
