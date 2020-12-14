//
//  RealmProvider.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2020-11-30.
//

import Foundation
import RealmSwift

class RealmProvider {
    class func realm() -> Realm {
        var realm: Realm
        do {
            if NSClassFromString("XCTest") != nil {
                realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
            } else {
                realm = try Realm()
                #if DEBUG
                print("Realm database: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
                #endif
            }
        } catch let error as NSError {
            fatalError("Error al abrir el realm. Error: \(error.localizedDescription)")
        }
        return realm
    }
}
