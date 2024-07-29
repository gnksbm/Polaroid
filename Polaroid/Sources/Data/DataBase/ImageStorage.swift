//
//  ImageStorage.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

final class ImageStorage {
    private let fileManager = FileManager.default
    
    private var documentURL: URL {
        guard let url = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { fatalError("Document 경로 찾을 수 없음") }
        return url
    }
    
    func addImage(_ data: Data?, additionalPath: String) throws -> String? {
        guard let encodedPath = additionalPath.addingPercentEncoding(
            withAllowedCharacters: .urlUserAllowed
        ) else { throw ImageStorageError.invalidPath }
        let fileURL = documentURL.appendingPathComponent(
            encodedPath,
            conformingTo: .jpeg
        )
        if !fileManager.fileExists(atPath: fileURL.currentPath) {
            try data?.write(to: fileURL)
        }
        return encodedPath
    }
    
    func removeImage(additionalPath: String) throws {
        let fileURL = documentURL.appendingPathComponent(
            additionalPath,
            conformingTo: .jpeg
        )
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
    }
}

extension ImageStorage {
    enum ImageStorageError: Error {
        case invalidPath
    }
}
