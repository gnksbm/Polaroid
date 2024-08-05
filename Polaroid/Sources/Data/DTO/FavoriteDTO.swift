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
    @Persisted var localURL: String?
    @Persisted var likeCount: Int?
    @Persisted var isLiked: Bool = true
    @Persisted var color: String?
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
        self.color = likableImage.color
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
    
    convenience init(randomImage: RandomImage) {
        self.init()
        self.id = randomImage.id
        self.imageURL = randomImage.imageURL?.absoluteString
        self.localURL = randomImage.localURL
        self.date = .now
        self.creatorProfileImageURL = 
        randomImage.creatorProfileImageURL?.absoluteString
        self.creatorProfileImageLocalPath =
        randomImage.creatorProfileImageLocalPath
        self.creatorName = randomImage.creatorName
        self.createdAt = randomImage.createdAt
        self.imageWidth = randomImage.imageWidth
        self.imageHeight = randomImage.imageHeight
    }
    
    convenience init(detailImage: DetailImage) {
        self.init()
        self.id = detailImage.id
        self.imageURL = detailImage.imageURL?.absoluteString
        self.localURL = detailImage.localURL
        self.date = .now
        self.creatorProfileImageURL = 
        detailImage.creatorProfileImageURL?.absoluteString
        self.creatorProfileImageLocalPath =
        detailImage.creatorProfileImageLocalPath
        self.creatorName = detailImage.creatorName
        self.createdAt = detailImage.createdAt
        self.imageWidth = detailImage.imageWidth
        self.imageHeight = detailImage.imageHeight
    }
}

extension FavoriteDTO {
    func toLikableImage() -> LikableImage {
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
    
    func toRandomImage() -> RandomImage {
        var imagePath: URL?
        var profilePath: URL?
        if let imageURL {
            imagePath = URL(string: imageURL)
        }
        if let creatorProfileImageURL {
            profilePath = URL(string: creatorProfileImageURL)
        }
        return RandomImage(
            id: id,
            imageURL: imagePath,
            localURL: localURL,
            creatorProfileImageURL: profilePath,
            creatorProfileImageLocalPath: creatorProfileImageLocalPath,
            creatorName: creatorName,
            createdAt: createdAt,
            imageWidth: imageWidth,
            imageHeight: imageHeight,
            isLiked: isLiked
        )
    }
    
    func toDetailImage() -> DetailImage {
        var imagePath: URL?
        var profilePath: URL?
        if let imageURL {
            imagePath = URL(string: imageURL)
        }
        if let creatorProfileImageURL {
            profilePath = URL(string: creatorProfileImageURL)
        }
        return DetailImage(
            id: id,
            creatorProfileImageURL: profilePath,
            creatorProfileImageLocalPath: creatorProfileImageLocalPath,
            creatorName: creatorName,
            createdAt: createdAt,
            imageURL: imagePath,
            localURL: localURL,
            isLiked: isLiked,
            imageWidth: imageWidth,
            imageHeight: imageHeight
        )
    }
}
