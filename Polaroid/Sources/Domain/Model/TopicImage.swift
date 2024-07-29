//
//  TopicImage.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

struct TopicImage: Hashable {
    let id: String
    let imageURL: URL?
    var localURL: String?
    let creatorProfileImageURL: URL?
    var creatorProfileImageLocalPath: String?
    let likeCount: Int
    let creatorName: String
    let createdAt: Date?
    let imageWidth: Int
    let imageHeight: Int
    var isLiked: Bool = false
}

extension TopicImage: MinimumImageData { }
