//
//  Realm+CascadeDeleting.swift
//  Poliplanner
//
//  Created by Mateo Fidabel on 2021-01-12.
//  https://gist.github.com/samrayner/44d34fdc77e7d8d766fd467d557753a9

import Foundation
import RealmSwift
import Realm

// Forked from: https://gist.github.com/krodak/b47ea81b3ae25ca2f10c27476bed450c
/// Indica que al eliminarse este objeto, deberan eliminarse ciertos atributos más
internal protocol CascadingDeletable: RealmSwift.Object {
    
    /// Una lista de atributos que serán eliminado cuando se elimine este objeto
    static var propertiesToCascadeDelete: [String] { get }
    
}

extension Realm {
    
    /// Elimina el objeto teniendo en cuenta los atributos que se indicarón que se van a eliminar
    /// - Parameter object: Objecto que se desea eliminar
    internal func cascadingDelete(_ object: RealmSwift.Object) {
        var toBeDeleted: Set<RLMObjectBase> = [object]
        while let element = toBeDeleted.popFirst() as? RealmSwift.Object {
            guard !element.isInvalidated else { continue }
            if let cascadingDeletable = element as? CascadingDeletable {
                cascade(into: cascadingDeletable, toBeDeleted: &toBeDeleted)
            }
            delete(element)
        }
    }

    /// Agrega los objetos que serán eliminados en cascada al conjunto de objetos a ser eliminados
    /// - Parameters:
    ///   - object: Objeto padre que contiene estos elementos como sus atributos
    ///   - toBeDeleted: Conjunto de objetos a ser eliminados
    private func cascade(into object: CascadingDeletable, toBeDeleted: inout Set<RLMObjectBase>) {
        let objectType = type(of: object)

        guard let schema = objectType.sharedSchema() else { return }

        let primaryKey = objectType.primaryKey()
        let primaryKeyValue = primaryKey.flatMap(object.value(forKey:))

        let properties = (schema.properties + schema.computedProperties)
            .filter { objectType.propertiesToCascadeDelete.contains($0.name) }

        for property in properties {
            switch object.value(forKey: property.name) {
            case let realmObject as RLMObjectBase:
                toBeDeleted.insert(realmObject)
            case let list as RLMListBase:
                for index in 0 ..< list._rlmArray.count {
                    guard let realmObject = list._rlmArray.object(at: index) as? RLMObjectBase else { continue }
                    toBeDeleted.insert(realmObject)
                }
            default: // LinkingObjects
                if let linkOriginPropertyName = property.linkOriginPropertyName,
                   let linkOriginTypeName = property.objectClassName,
                   let primaryKey = primaryKey,
                   let primaryKeyValue = primaryKeyValue {
                    dynamicObjects(linkOriginTypeName)
                        .filter("%K == %@", "\(linkOriginPropertyName).\(primaryKey)", primaryKeyValue)
                        .forEach { toBeDeleted.insert($0) }
                }
            }
        }
    }
}
