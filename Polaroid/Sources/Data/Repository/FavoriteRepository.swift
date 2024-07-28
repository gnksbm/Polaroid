//
//  FavoriteRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

import RealmSwift

final class FavoriteRepository {
    private let realmStorage = RealmStorage()
    private let imageStorage = ImageStorage()
    
    func saveImage(_ imageData: LikableImageData) throws -> LikableImage {
        guard !fetchObject().contains(where: { $0.id == imageData.item.id })
        else {
            throw FavoriteRepositoryError.duplicatedImage
        }
        guard let data = imageData.data else {
            throw FavoriteRepositoryError.noData
        }
        guard let imageURLStr = imageData.item.imageURL?.absoluteString
        else {
            throw FavoriteRepositoryError.noURL
        }
        let localURL = try imageStorage.addImage(
            data,
            additionalPath: imageURLStr
        )
        var newImage = imageData.item
        newImage.localURL = localURL
        let imageObject = FavoriteDTO(likableImage: newImage)
        do {
            try realmStorage.create(imageObject)
        } catch {
            try imageStorage.removeImage(additionalPath: imageURLStr)
            throw error
        }
        var result = imageObject.toDomain()
        result.isLikeCountHidden = false
        return result
    }
    
    func reConfigureImages(_ images: [LikableImage]) -> [LikableImage] {
        images.map { image in
            var copy = image
            if !fetchObject().where({ $0.id.equals(image.id) }).isEmpty {
                copy.isLiked = true
            }
            return copy
        }
    }
    
    func fetchImage() -> [LikableImage] {
        fetchObject().map { $0.toDomain() }
    }
    
    func fetchImage(with option: FavoriteSortOption) -> [LikableImage] {
        fetchObject()
            .sorted {
                switch option {
                case .latest:
                    $0.date > $1.date
                case .oldest:
                    $0.date < $1.date
                }
            }
            .map { $0.toDomain() }
    }
    
    func fetchImage(with color: ColorOption?) -> [LikableImage] {
        fetchObject()
            .where {
                if let color {
                    $0.color.equals(color.rawValue)
                } else {
                    $0.isLiked
                }
            }
            .map { $0.toDomain() }
    }
    
    func removeImage(_ likableImage: LikableImage) throws -> LikableImage {
        guard let object = fetchObject().where(
            { $0.id.equals(likableImage.id) }
        ).first
        else { return likableImage }
        try realmStorage.delete(object)
        var newImage = likableImage
        newImage.isLiked.toggle()
        return newImage
    }
    
    private func fetchObject() -> Results<FavoriteDTO> {
        realmStorage.read(FavoriteDTO.self)
    }
}

extension FavoriteRepository {
    enum FavoriteRepositoryError: Error {
        case noData, noURL, duplicatedImage
    }
}
