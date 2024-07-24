//
//  TopicRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

import Alamofire

final class TopicRepository {
    func fetchTopic(
        request: TopicRequest,
        _ completion: @escaping (Result<[MinimumUnsplashImage], Error>) -> Void
    ) {
        AF.request(TopicEndpoint(request: request))
            .responseDecodable(of: [TopicDTO].self) { response in
                let result = response.result
                    .map { dtos in
                        dtos.map { $0.toMinImage }
                    }
                    .mapError { error in
                        error as Error
                    }
                completion(result)
            }
    }
}
