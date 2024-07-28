//
//  StatisticsRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

final class StatisticsRepository {
    private let networkService = NetworkService.shared
    
    func fetchStatistics<T: MinimumImageData>(
        imageData: T,
        _ completion: @escaping (Result<DetailImage, Error>) -> Void
    ) {
        networkService.callRequest(
            endpoint: StatisticsEndpoint(
                request: StatisticsRequest(
                    imageID: imageData.id
                )
            )
        ) { result in
            completion(
                result.decode(type: StatisticsDTO.self)
                    .map { $0.toDetailImage(with: imageData) }
            )
        }
    }
}
