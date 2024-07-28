//
//  RandomImage.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

struct RandomImage {
    let id: String
    let imageURL: URL?
    var localURL: String?
    let creatorProfileImageURL: URL?
    var creatorProfileImageLocalPath: String?
    let creatorName: String
    let createdAt: Date?
    let imageWidth: Int
    let imageHeight: Int
    var isLiked: Bool
}

extension RandomImage: Hashable, Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}

extension RandomImage: MinimumImageData { }
