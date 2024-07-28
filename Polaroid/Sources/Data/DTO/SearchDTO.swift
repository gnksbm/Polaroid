//
//  SearchDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

struct SearchDTO: Codable {
    let total, totalPages: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

extension SearchDTO {
    func toSearchedImage() -> ([LikableImage], page: Int) {
        let images = results.map { result in
            LikableImage(
                id: result.id,
                imageURL: URL(string: result.urls.small),
                likeCount: result.likes,
                isLikeCountHidden: false,
                isLiked: false
            )
        }
        return (images, totalPages)
    }
}

extension SearchDTO {
    struct Result: Codable {
        let id: String
        let color: String
        let urls: Urls
        let likes: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case color
            case urls
            case likes
        }
    }
    
    struct Urls: Codable {
        let raw, full, regular, small: String
        let thumb, smallS3: String
        
        enum CodingKeys: String, CodingKey {
            case raw, full, regular, small, thumb
            case smallS3 = "small_s3"
        }
    }
}
