//
//  Secret.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

enum Secret {
    static let unsplashAPIKey = getPlistValue(
        type: String.self,
        key: "UNSPLASH_API_KEY"
    )
    
    private static func getPlistValue<T>(type: T.Type, key: String) -> T {
        guard let value = Bundle.main.object(
            forInfoDictionaryKey: key
        ) as? T else { fatalError("\(key) 찾을 수 없음") }
        return value
    }
}
