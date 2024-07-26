//
//  SearchedImage.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

struct SearchedImage: Hashable {
    let id: String
    let imageURL: URL?
    let likeCount: Int
    var isLiked: Bool
}
