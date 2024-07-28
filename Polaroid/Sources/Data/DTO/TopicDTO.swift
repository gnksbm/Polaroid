//
//  TopicDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import Foundation

struct TopicDTO: Decodable {
    let id: String
    let urls: Urls
    let likes: Int

    enum CodingKeys: String, CodingKey {
        case id
        case urls, likes
    }
}

extension TopicDTO {
    func toTopicImage() -> TopicImage {
        TopicImage(
            id: id,
            imageURL: URL(string: urls.small),
            likeCount: likes
        )
    }
}

extension TopicDTO {
    struct Urls: Codable {
        let raw, full, regular, small: String
        let thumb, smallS3: String
        
        enum CodingKeys: String, CodingKey {
            case raw, full, regular, small, thumb
            case smallS3 = "small_s3"
        }
    }
}
