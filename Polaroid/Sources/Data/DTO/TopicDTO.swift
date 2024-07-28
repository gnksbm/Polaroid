//
//  TopicDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import Foundation

struct TopicDTO: Decodable {
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

extension TopicDTO {
    func toTopicImage() -> TopicImage {
        TopicImage(
            id: id,
            imageURL: URL(string: urls.small),
            creatorProfileImageURL: URL(string: user.profileImage.medium),
            likeCount: likes,
            creatorName: user.name,
            createdAt: createdAt.iso8601Formatted(),
            imageWidth: width,
            imageHeight: height
        )
    }
}

extension TopicDTO {
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
