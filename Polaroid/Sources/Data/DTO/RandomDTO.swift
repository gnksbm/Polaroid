//
//  RandomDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

struct RandomDTO: Decodable {
    let id: String
    let createdAt: String
    let width, height: Int
    let color: String
    let urls: Urls
    let likes: Int
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color
        case urls, likes
        case user
    }
}

extension RandomDTO {
    func toRandomImage() -> RandomImage {
        RandomImage(
            id: id,
            imageURL: URL(string: urls.regular),
            creatorProfileImageURL: URL(string: user.profileImage.medium),
            creatorProfileImageLocalPath: nil,
            creatorName: user.name,
            createdAt: createdAt.iso8601Formatted(),
            imageWidth: width,
            imageHeight: height
        )
    }
}

extension RandomDTO {
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
