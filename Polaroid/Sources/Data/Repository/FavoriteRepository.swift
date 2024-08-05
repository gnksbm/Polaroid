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
        let localURL = try imageStorage.addImage(
            data,
            additionalPath: imageData.item.id
        )
        var newImage = imageData.item
        newImage.localURL = localURL
        let imageObject = FavoriteDTO(likableImage: newImage)
        do {
            try realmStorage.create(imageObject)
        } catch {
            try imageStorage.removeImage(additionalPath: imageData.item.id)
            throw error
        }
        var result = imageObject.toLikableImage()
        result.isLikeCountHidden = false
        return result
    }
    
    func saveImage(_ imageData: RandomImageData) throws -> RandomImage {
        guard fetchObject()
            .where({ $0.id.equals(imageData.item.id) })
            .isEmpty
        else {
            throw FavoriteRepositoryError.duplicatedImage
        }
        guard let imgData = imageData.imageData,
              let profileImageData = imageData.profileImageData else {
            throw FavoriteRepositoryError.noData
        }
        let localURL = try imageStorage.addImage(
            imgData,
            additionalPath: imageData.item.id
        )
        let localProfileURL = try imageStorage.addImage(
            profileImageData,
            additionalPath: imageData.item.creatorName
        )
        var newImage = imageData.item
        newImage.localURL = localURL
        newImage.creatorProfileImageLocalPath = localProfileURL
        let imageObject = FavoriteDTO(randomImage: newImage)
        do {
            try realmStorage.create(imageObject)
        } catch {
            try imageStorage.removeImage(additionalPath: imageData.item.id)
            try imageStorage.removeImage(
                additionalPath: imageData.item.creatorName
            )
            throw error
        }
        return imageObject.toRandomImage()
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
        let localURL = try imageStorage.addImage(
            imageData,
            additionalPath: image.id
        )
        let localProfileURL = try imageStorage.addImage(
            profileImageData,
            additionalPath: image.creatorName
        )
        var newImage = image
        newImage.localURL = localURL
        newImage.creatorProfileImageLocalPath = localProfileURL
        let imageObject = FavoriteDTO(detailImage: newImage)
        do {
            try realmStorage.create(imageObject)
        } catch {
            try imageStorage.removeImage(additionalPath: image.id)
            try imageStorage.removeImage(additionalPath: image.creatorName)
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
            } else {
                copy.isLiked = false
                copy.localURL = nil
            }
            return copy
        }
    }
    
    func reConfigureImage(_ image: DetailImage) -> DetailImage {
        var copy = image
        if let object = fetchObject().where({ $0.id.equals(image.id) }).first {
            copy.isLiked = true
            copy.localURL = object.localURL
        } else {
            copy.isLiked = false
            copy.localURL = nil
        }
        return copy
    }
    
    func reConfigureImages(_ images: [RandomImage]) -> [RandomImage] {
        images.map { image in
            var copy = image
            if let object = fetchObject().where({ $0.id.equals(image.id) })
                .first {
                copy.isLiked = true
                copy.localURL = object.localURL
            } else {
                copy.isLiked = false
                copy.localURL = nil
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
                    $0.date < $1.date
                case .oldest:
                    $0.date > $1.date
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
        if let profileLocalURL = likableImage.creatorProfileImageLocalPath {
            try imageStorage.removeImage(additionalPath: profileLocalURL)
        }
        try realmStorage.delete(object)
        var newImage = likableImage
        newImage.isLiked = false
        newImage.localURL = nil
        return newImage
    }
    
    func removeImage(_ randomImage: RandomImage) throws -> RandomImage {
        var newImage = randomImage
        newImage.isLiked = false
        newImage.localURL = nil
        guard let object = fetchObject().where(
            { $0.id.equals(randomImage.id) }
        ).first
        else { return newImage }
        if let localURL = randomImage.localURL {
            try imageStorage.removeImage(additionalPath: localURL)
        }
        if let profileURL = randomImage.creatorProfileImageLocalPath {
            try imageStorage.removeImage(additionalPath: profileURL)
        }
        try realmStorage.delete(object)
        return newImage
    }
    
    func removeImage(_ detailImage: DetailImage) throws -> DetailImage {
        guard let object = fetchObject().where(
            { $0.id.equals(detailImage.id) }
        ).first
        else { return detailImage }
        if let localURL = detailImage.localURL {
            try imageStorage.removeImage(additionalPath: localURL)
        }
        if let profileURL = detailImage.creatorProfileImageLocalPath {
            try imageStorage.removeImage(additionalPath: profileURL)
        }
        try realmStorage.delete(object)
        var newImage = detailImage
        newImage.isLiked = false
        newImage.localURL = nil
        newImage.creatorProfileImageLocalPath = nil
        return newImage
    }
    
    func removeAll() throws {
        try fetchObject().forEach {
            try realmStorage.delete($0)
        }
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
