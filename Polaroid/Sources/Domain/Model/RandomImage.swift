//
//  RandomImage.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

struct RandomImage: Hashable {
    let id: String
    let imageURL: URL?
    let creatorProfileImageURL: URL?
    let creatorProfileImageLocalPath: String?
    let creatorName: String
    let createdAt: Date?
    let imageWidth: Int
    let imageHeight: Int
    var isLiked: Bool
}

extension RandomImage: MinimumImageData { }
