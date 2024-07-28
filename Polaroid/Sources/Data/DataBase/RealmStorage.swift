//
//  RealmStorage.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import Foundation

import RealmSwift

final class RealmStorage {
    private let realm = try! Realm()
    
    func create(_ object: Object) throws {
        try realm.write {
            realm.add(object)
        }
    }
    
    func read<T: Object>(
        _ type: T.Type
    ) -> Results<T> {
        realm.objects(type)
    }
    
    func update<T: Object>(
        _ object: T,
        _ block: (T) -> Void
    ) throws {
        try realm.write {
            block(object)
        }
    }
    
    func delete(_ object: Object) throws {
        try realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAll() {
        realm.deleteAll()
    }
}

extension RealmStorage {
    static let shared = RealmStorage()
}
