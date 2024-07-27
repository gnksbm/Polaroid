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
    
    func saveImage(_ imageData: LikableImageData) throws {
        guard let data = imageData.data else {
            throw FavoriteRepositoryError.noData
        }
        guard let path = imageData.item.imageURL?.absoluteString else {
            throw FavoriteRepositoryError.noURL
        }
        try imageStorage.addImage(data, additionalPath: path)
        let imageObject = FavoriteDTO(likableImage: imageData.item)
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
    
    func fetchImage(with option: FavoriteSortOption) -> [LikableImage] {
        realmStorage.read(FavoriteDTO.self)
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
    
    func fetchImage(with color: ColorOption) -> [LikableImage] {
        realmStorage.read(FavoriteDTO.self)
            .where { $0.color.equals(color.rawValue) }
            .map { $0.toDomain() }
    }
    
    func removeImage(_ likableImage: LikableImage) throws {
        try realmStorage.delete(FavoriteDTO(likableImage: likableImage))
    }
    
    enum FavoriteRepositoryError: Error {
        case noData, noURL
    }
}


