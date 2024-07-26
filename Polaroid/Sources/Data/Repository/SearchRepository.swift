//
//  SearchRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

final class SearchRepository {
    private let networkService = NetworkService.shared
    
    func search(
        request: SearchRequest,
        _ completion:
        @escaping (Result<(images: [LikableImage], page: Int), Error>) -> Void
    ) {
        networkService.callRequest(
            endpoint: SearchEndpoint(request: request)
        ) { result in
            completion(
                result.decode(type: SearchDTO.self)
                    .map { $0.toSearchedImage() }
            )
        }
    }
}
