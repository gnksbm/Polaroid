//
//  FavoriteRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

import RealmSwift

final class FavoriteRepository {
    static let shared = FavoriteRepository()
    
    private let realmStorage = RealmStorage()
    private let imageStorage = ImageStorage()
    
    private init() { }
    
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
        var result = imageObject.toLikableImage()
        result.isLikeCountHidden = false
        return result
    }
    
    func saveImage(_ imageData: RandomImageData) throws -> RandomImage {
        guard !fetchObject().contains(where: { $0.id == imageData.item.id })
        else {
            throw FavoriteRepositoryError.duplicatedImage
        }
        guard let imgData = imageData.imageData,
              let profileImageData = imageData.profileImageData else {
            throw FavoriteRepositoryError.noData
        }
        guard let imageURLStr = imageData.item.imageURL?.absoluteString,
              let profileURLStr = imageData.item.creatorProfileImageURL?
            .absoluteString
        else {
            throw FavoriteRepositoryError.noURL
        }
        let localURL = try imageStorage.addImage(
            imgData,
            additionalPath: imageURLStr
        )
        let localProfileURL = try imageStorage.addImage(
            profileImageData,
            additionalPath: profileURLStr
        )
        var newImage = imageData.item
        newImage.localURL = localURL
        newImage.creatorProfileImageLocalPath = localProfileURL
        let imageObject = FavoriteDTO(randomImage: newImage)
        do {
            try realmStorage.create(imageObject)
        } catch {
            try imageStorage.removeImage(additionalPath: imageURLStr)
            throw error
        }
        var result = imageObject.toRandomImage()
        return result
    }
    
    func saveImage(
        _ image: DetailImage,
        imageData: Data?,
        profileImageData: Data?
    ) throws -> DetailImage {
        guard !fetchObject().contains(where: { $0.id == image.id })
        else {
            throw FavoriteRepositoryError.duplicatedImage
        }
        guard let imageData, let profileImageData else {
            throw FavoriteRepositoryError.noData
        }
        guard let imageURLStr = image.imageURL?.absoluteString,
              let profileURLStr = image.creatorProfileImageURL?.absoluteString
        else {
            throw FavoriteRepositoryError.noURL
        }
        let localURL = try imageStorage.addImage(
            imageData,
            additionalPath: imageURLStr
        )
        let localProfileURL = try imageStorage.addImage(
            profileImageData,
            additionalPath: profileURLStr
        )
        var newImage = image
        newImage.localURL = localURL
        newImage.creatorProfileImageLocalPath = localProfileURL
        let imageObject = FavoriteDTO(detailImage: newImage)
        do {
            try realmStorage.create(imageObject)
        } catch {
            try imageStorage.removeImage(additionalPath: imageURLStr)
            try imageStorage.removeImage(additionalPath: profileURLStr)
            throw error
        }
        return imageObject.toDetailImage()
    }
    
    func reConfigureImages(_ images: [LikableImage]) -> [LikableImage] {
        images.map { image in
            var copy = image
            if let object = fetchObject().where({ $0.id.equals(image.id) })
                .first {
                copy.isLiked = true
                copy.localURL = object.localURL
            }
            return copy
        }
    }
    
    func reConfigureImages(_ image: DetailImage) -> DetailImage {
        var copy = image
        if let object = fetchObject().where({ $0.id.equals(image.id) }).first {
            copy.isLiked = true
            copy.localURL = object.localURL
        }
        return copy
    }
    
    func reConfigureImages(_ images: [RandomImage]) -> [RandomImage] {
        images.map { image in
            var copy = image
            if !fetchObject().where({ $0.id.equals(image.id) }).isEmpty {
                copy.isLiked = true
            }
            return copy
        }
    }
    
    func fetchImage() -> [LikableImage] {
        fetchObject().map { $0.toLikableImage() }
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
            .map { $0.toLikableImage() }
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
            .map { $0.toLikableImage() }
    }
    
    func removeImage(_ likableImage: LikableImage) throws -> LikableImage {
        guard let object = fetchObject().where(
            { $0.id.equals(likableImage.id) }
        ).first
        else { return likableImage }
        if let localURL = likableImage.localURL {
            try imageStorage.removeImage(additionalPath: localURL)
        }
        try realmStorage.delete(object)
        var newImage = likableImage
        newImage.isLiked.toggle()
        newImage.localURL = nil
        return newImage
    }
    
    func removeImage(_ randomImage: RandomImage) throws -> RandomImage {
        guard let object = fetchObject().where(
            { $0.id.equals(randomImage.id) }
        ).first
        else { return randomImage }
        if let localURL = randomImage.localURL,
           let profileURL = randomImage.creatorProfileImageLocalPath {
            try imageStorage.removeImage(additionalPath: localURL)
            try imageStorage.removeImage(additionalPath: profileURL)
        }
        try realmStorage.delete(object)
        var newImage = randomImage
        newImage.isLiked.toggle()
        newImage.localURL = nil
        return newImage
    }
    
    func removeImage(_ detailImage: DetailImage) throws -> DetailImage {
        guard let object = fetchObject().where(
            { $0.id.equals(detailImage.id) }
        ).first
        else { return detailImage }
        if let localURL = detailImage.localURL,
           let profileURL = detailImage.creatorProfileImageLocalPath {
            try imageStorage.removeImage(additionalPath: localURL)
            try imageStorage.removeImage(additionalPath: profileURL)
        }
        try realmStorage.delete(object)
        var newImage = detailImage
        newImage.isLiked.toggle()
        newImage.localURL = nil
        newImage.creatorProfileImageLocalPath = nil
        return newImage
    }
    
    func removeAll() {
        realmStorage.deleteAll()
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
