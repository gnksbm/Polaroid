//
//  NetworkService.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

import Alamofire

final class NetworkService {
    static let shared = NetworkService()
    
    private init() { }
    
    func callRequest(
        endpoint: EndpointRepresentable,
        _ completion: @escaping (Result<Data, Error>) -> Void
    ) {
        AF.request(endpoint)
            .response { response in
                completion(
                    response.result.mapError { error in error as Error }
                        .flatMap { data in
                            guard let data
                            else { return .failure(NetworkError.noData) }
                            return .success(data)
                        }
                )
            }
    }
}
