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
            .response { response in
                let result = response.result
                    .mapError { error in
                        error as Error
                    }
                    .map { data in
                        guard let data else {
                            return [MinimumUnsplashImage]()
                        }
                        do {
                            let dto = try JSONDecoder().decode(
                                [TopicDTO].self,
                                from: data
                            )
                            return dto.map { $0.toMinImage }
                        } catch {
                            Logger.error(error)
                            return []
                        }
                }
                completion(result)
            }
    }
}
