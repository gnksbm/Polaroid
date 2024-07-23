//
//  RealmStorage+Migration.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import Foundation

import RealmSwift

extension RealmStorage {
    enum RealmVersion: Int, CaseIterable {
        case origin
    }
}

extension RealmStorage {
    static func migrateIfNeeded() {
        guard let url = Realm.Configuration.defaultConfiguration.fileURL else {
            Logger.debug("Realm 경로 찾을 수 없음")
            return
        }
        do {
            let version = try schemaVersionAtURL(url)
            if version < RealmVersion.latestVersion {
                migrate(currentVersion: Int(version))
            } else {
                Realm.Configuration.defaultConfiguration.schemaVersion = version
            }
        } catch {
            Logger.error(error)
        }
    }
    
    private static func migrate(currentVersion: Int) {
        let config = Realm.Configuration(
            schemaVersion: UInt64(RealmVersion.latestVersion)
        ) { migration, oldSchemaVersion in
            RealmVersion.migrate(
                migration: migration,
                version: Int(oldSchemaVersion)
            )
        }
        Realm.Configuration.defaultConfiguration = config
    }
}

extension RealmStorage.RealmVersion {
    static let latestVersion = allCases.count - 1
        
    fileprivate static func migrate(migration: Migration, version: Int) {
        (version..<latestVersion).forEach { versionNum in
            switch allCases[versionNum] {
            case .origin:
                break
            }
        }
    }
}
