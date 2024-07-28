//
//  SearchDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

struct SearchDTO: Decodable {
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
                isLiked: false,
                creatorProfileImageURL:
                    URL(string: result.user.profileImage.medium),
                creatorName: result.user.name,
                createdAt: result.createdAt.iso8601Formatted(),
                imageWidth: result.width,
                imageHeight: result.height
            )
        }
        return (images, totalPages)
    }
}

extension SearchDTO {
    struct Result: Decodable {
        let id: String
        let color: String
        let urls: Urls
        let likes: Int
        let createdAt: String
        let width, height: Int
        let user: User
        
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case width, height, color
            case urls, likes
            case user
        }
    }
    
    struct Urls: Decodable {
        let raw, full, regular, small: String
        let thumb, smallS3: String
        
        enum CodingKeys: String, CodingKey {
            case raw, full, regular, small, thumb
            case smallS3 = "small_s3"
        }
    }
    
    struct User: Decodable {
        let name: String
        let profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case name
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImage: Decodable {
        let small, medium, large: String
    }
}
