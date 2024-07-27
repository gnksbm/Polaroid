//
//  LikableImage.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

struct LikableImage: Hashable {
    let id: String
    let imageURL: URL?
    let likeCount: Int?
    var isLiked: Bool
    var localURL: URL?
    var color: String
}
