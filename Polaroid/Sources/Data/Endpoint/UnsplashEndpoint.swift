//
//  UnsplashEndpoint.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

protocol UnsplashEndpoint: EndpointRepresentable { }

extension UnsplashEndpoint {
    var httpMethod: HTTPMethod { .get }
    var scheme: Scheme { .https }
    var host: String { "api.unsplash.com" }
    
    func toURL() -> URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.port = port
        components.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        components.queryItems?.append(
            URLQueryItem(name: "client_id", value: Secret.unsplashAPIKey)
        )
        return components.url
    }
}
