//
//  LikableImage.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

struct LikableImage {
    let id: String
    let imageURL: URL?
    let likeCount: Int?
    var isLikeCountHidden: Bool
    var isLiked: Bool
    var localURL: String?
    var color: String?
    let creatorProfileImageURL: URL?
    var creatorProfileImageLocalPath: String?
    let creatorName: String
    let createdAt: Date?
    let imageWidth: Int
    let imageHeight: Int
}

extension LikableImage: Hashable, Identifiable { 
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}

extension LikableImage: MinimumImageData { }
