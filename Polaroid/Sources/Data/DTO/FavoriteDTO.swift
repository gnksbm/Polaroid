//
//  FavoriteDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

import RealmSwift

final class FavoriteDTO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var imageURL: String?
    @Persisted var likeCount: Int?
    @Persisted var isLiked: Bool = true
    
    convenience init(likableImage: LikableImage) {
        self.init()
        self.id = id
        self.imageURL = likableImage.imageURL?.absoluteString
        self.likeCount = likableImage.likeCount
    }
}

extension FavoriteDTO {
    func toDomain() -> LikableImage {
        var url: URL?
        if let imageURL {
            url = URL(string: imageURL)
        }
        return LikableImage(
            id: id,
            imageURL: url,
            likeCount: likeCount,
            isLiked: isLiked,
            localURL: url
        )
    }
}
