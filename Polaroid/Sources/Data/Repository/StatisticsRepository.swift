//
//  StatisticsRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

final class StatisticsRepository {
    private let networkService = NetworkService.shared
    
    func fetchStatistics(
        request: StatisticsRequest,
        _ completion: @escaping (Result<[TopicImage], Error>) -> Void
    ) {
        networkService.callRequest(
            endpoint: StatisticsEndpoint(request: request)
        ) { result in
//            completion(
//                result.decode(type: StatisticsDTO.self)
//            )
        }
    }
}
