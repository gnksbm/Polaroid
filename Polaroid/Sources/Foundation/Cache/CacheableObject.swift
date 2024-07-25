//
//  CacheableObject.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

final class CacheableObject<Value: Codable>: Codable {
    let value: Value
    let validationField: ValidationField
    let date: Date
    
    init(value: Value, validationField: ValidationField) {
        self.value = value
        self.validationField = validationField
        date = .now
    }
    
    init?(value: Value, headers: [AnyHashable: Any]) {
        if let eTag = headers["ETag"] as? String {
            self.validationField = .eTag(eTag)
        } else if let lastModified = headers["Last-Modified"] as? String {
            self.validationField = .lastModified(lastModified)
        } else {
            return nil
        }
        self.value = value
        date = .now
    }
    
    func toURLRequest(url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(
            validationField.requestHeaderValue,
            forHTTPHeaderField: validationField.requestKey
        )
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        return urlRequest
    }
    
    func updatingDate() -> Self {
        Self(value: value, validationField: validationField)
    }
    
    enum ValidationField: Codable {
        case eTag(String), lastModified(String)
        
        var requestKey: String {
            switch self {
            case .eTag:
                "If-None-Match"
            case .lastModified:
                "If-Modified-Since"
            }
        }
        
        var requestHeaderValue: String {
            switch self {
            case .eTag(let eTag):
                eTag
            case .lastModified(let modifiedDate):
                modifiedDate
            }
        }
    }
}
