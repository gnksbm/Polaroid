//
//  RandomRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

import Alamofire

final class RandomRepository {
    func fetchRandom(
        _ completion: @escaping (Result<[RandomImage], Error>) -> Void
    ) {
        AF.request(RandomEndpoint())
            .responseDecodable(of: [RandomDTO].self) { response in
                completion(
                    response.result
                        .mapError { error in error as Error }
                        .flatMap { .success($0.map { $0.toRandomImage() }) }
                )
            }
    }
}
