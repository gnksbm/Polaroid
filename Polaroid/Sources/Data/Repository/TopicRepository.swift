//
//  TopicRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

final class TopicRepository {
    private let networkService = NetworkService.shared
    
    func fetchTopic(
        request: TopicRequest,
        _ completion: @escaping (Result<[TopicImage], Error>) -> Void
    ) {
        networkService.callRequest(
            endpoint: TopicEndpoint(request: request)
        ) { result in
            completion(
                result.decode(type: [TopicDTO].self)
                    .map { $0.map { $0.toTopicImage() } }
            )
        }
    }
}
