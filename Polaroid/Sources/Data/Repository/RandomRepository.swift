//
//  RandomRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

final class RandomRepository {
    static let shared = RandomRepository()
    
    private let networkService = NetworkService.shared
    
    private init() { }
    
    func fetchRandom(
        _ completion: @escaping (Result<[RandomImage], Error>) -> Void
    ) {
        networkService.callRequest(endpoint: RandomEndpoint()) { result in
            completion(
                result.decode(type: [RandomDTO].self)
                    .map { $0.map { $0.toRandomImage() } }
            )
        }
    }
}
