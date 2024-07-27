//
//  FavoriteDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

import RealmSwift

final class FavoriteDTO: Object {
    @Persisted var id: String
    @Persisted var imageURL: String?
    @Persisted var localURL: String?
    @Persisted var likeCount: Int?
    @Persisted var isLiked: Bool = true
    @Persisted var color: String
    @Persisted var date: Date
    
    convenience init(likableImage: LikableImage) {
        self.init()
        self.id = likableImage.id
        self.imageURL = likableImage.imageURL?.absoluteString
        self.localURL = likableImage.localURL
        self.likeCount = likableImage.likeCount
        self.date = .now
    }
}

extension FavoriteDTO {
    func toDomain() -> LikableImage {
        var imagePath: URL?
        if let imageURL {
            imagePath = URL(string: imageURL)
        }
        return LikableImage(
            id: id,
            imageURL: imagePath,
            likeCount: likeCount,
            isLiked: isLiked,
            localURL: localURL,
            color: color
        )
    }
}
