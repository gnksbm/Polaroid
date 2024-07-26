//
//  FavoriteRepository.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

final class FavoriteRepository {
    private let realmStorage = RealmStorage()
    private let imageStorage = ImageStorage()
    
    func saveImage(_ likableImage: LikableImage, imageData: Data?) throws {
        guard let data = imageData else { throw FavoriteRepositoryError.noData }
        guard let path = likableImage.imageURL?.absoluteString else {
            throw FavoriteRepositoryError.noURL
        }
        try imageStorage.addImage(data, additionalPath: path)
        let imageObject = FavoriteDTO(likableImage: likableImage)
        do {
            try realmStorage.create(imageObject)
        } catch {
            try imageStorage.removeImage(additionalPath: path)
            throw error
        }
    }
    
    func fetchImage() -> [LikableImage] {
        realmStorage.read(FavoriteDTO.self).map { $0.toDomain() }
    }
    
    func removeImage(_ likableImage: LikableImage) throws {
        try realmStorage.delete(FavoriteDTO(likableImage: likableImage))
    }
    
    enum FavoriteRepositoryError: Error {
        case noData, noURL
    }
}


