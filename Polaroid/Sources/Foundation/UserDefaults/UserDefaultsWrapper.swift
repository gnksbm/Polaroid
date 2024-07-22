//
//  UserDefaultsWrapper.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<T: Codable> {
    private let key: UserDefaultsKey
    private var defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key.rawValue)
            else {
                return defaultValue
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                Logger.error(error)
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: key.rawValue)
            } catch {
                Logger.error(error)
            }
        }
    }
    
    init(key: UserDefaultsKey, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var isSaved: Bool {
        UserDefaults.standard.data(forKey: key.rawValue) != nil
    }
    
    func removeValue() {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    mutating func updateDefaultValue(newValue: T) {
        defaultValue = newValue
    }
}
