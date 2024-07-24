//
//  EndpointRepresentable.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

import Alamofire

protocol EndpointRepresentable: URLConvertible, URLRequestConvertible {
    var httpMethod: HTTPMethod { get }
    var scheme: Scheme { get }
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
    var queries: [String: String]? { get }
    var header: [String : String]? { get }
    var body: [String: any Encodable]? { get }
    
    func toURLRequest() -> URLRequest?
    func toURL() -> URL?
}

extension EndpointRepresentable {
    var port: Int? { nil }
    var queries: [String: String]? { nil }
    var header: [String : String]? { nil }
    var body: [String: any Encodable]? { nil }
    
    func toURL() -> URL? {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.port = port
        components.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return components.url
    }
    
    func toURLRequest() -> URLRequest? {
        guard let url = toURL() else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = httpMethod.rawValue
        if let body {
            let httpBody = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = httpBody
        }
        return request
    }
}

extension EndpointRepresentable {
    func asURL() throws -> URL {
        guard let url = toURL() else { throw EndpointError.invalidURL }
        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let urlRequest = toURLRequest()
        else { throw EndpointError.invalidURLRequest }
        return urlRequest
    }
}
