//
//  LikableImage.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

struct LikableImage: Hashable, Identifiable {
    let id: String
    let imageURL: URL?
    let likeCount: Int?
    var isLiked: Bool
    var localURL: String?
    var color: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}
