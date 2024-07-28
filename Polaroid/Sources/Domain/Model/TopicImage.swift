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
    let creatorProfileImageURL: URL?
    var creatorProfileImageLocalPath: URL?
    let likeCount: Int
    let creatorName: String
    let createdAt: Date?
    let imageWidth: Int
    let imageHeight: Int
}

extension TopicImage: MinimumImageData { }
