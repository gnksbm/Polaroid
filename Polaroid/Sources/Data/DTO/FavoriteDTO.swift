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
    @Persisted var creatorProfileImageURL: String?
    @Persisted var creatorProfileImageLocalPath: String?
    @Persisted var creatorName: String
    @Persisted var createdAt: Date?
    @Persisted var imageWidth: Int
    @Persisted var imageHeight: Int
    
    convenience init(likableImage: LikableImage) {
        self.init()
        self.id = likableImage.id
        self.imageURL = likableImage.imageURL?.absoluteString
        self.localURL = likableImage.localURL
        self.likeCount = likableImage.likeCount
        self.date = .now
        self.creatorProfileImageURL = 
        likableImage.creatorProfileImageURL?.absoluteString
        self.creatorProfileImageLocalPath =
        likableImage.creatorProfileImageLocalPath
        self.creatorName = likableImage.creatorName
        self.createdAt = likableImage.createdAt
        self.imageWidth = likableImage.imageWidth
        self.imageHeight = likableImage.imageHeight
    }
}

extension FavoriteDTO {
    func toDomain() -> LikableImage {
        var imagePath: URL?
        var profilePath: URL?
        if let imageURL {
            imagePath = URL(string: imageURL)
        }
        if let creatorProfileImageURL {
            profilePath = URL(string: creatorProfileImageURL)
        }
        return LikableImage(
            id: id,
            imageURL: imagePath,
            likeCount: likeCount,
            isLikeCountHidden: true,
            isLiked: isLiked,
            localURL: localURL,
            color: color,
            creatorProfileImageURL: profilePath,
            creatorProfileImageLocalPath: creatorProfileImageLocalPath,
            creatorName: creatorName,
            createdAt: createdAt,
            imageWidth: imageWidth,
            imageHeight: imageHeight
        )
    }
}
