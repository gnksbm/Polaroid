//
//  CacheService.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

protocol CacheService {
    associatedtype Value: Codable
    
    func object(url: URL) -> CacheableObject<Value>?
    func setObject(_ object: CacheableObject<Value>, url: URL)
}

final class DefaultCacheService<Value: Codable>: CacheService {
    private let memoryStorage = NSCache<NSURL, CacheableObject<Value>>()
    private let diskStorage = DiskStorage<Value>()
    
    init(config: CacheConfiguration = .default) {
        memoryStorage.countLimit = config.countLimit
        memoryStorage.totalCostLimit = config.totalCostLimit
    }
    
    func object(url: URL) -> CacheableObject<Value>? {
        if let objectInMemory = memoryStorage.object(forKey: url as NSURL) {
            return objectInMemory
        }
        return diskStorage.object(url: url)
    }
    
    func setObject(_ object: CacheableObject<Value>, url: URL) {
        memoryStorage.setObject(object, forKey: url as NSURL)
        diskStorage.setObject(object, url: url)
    }
}

final class DiskStorage<Value: Codable> {
    private let fileManager = FileManager.default
    
    private var cacheDirectoryURL: URL {
        guard let url = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first
        else { fatalError("디스크 캐시 저장소 찾을 수 없음") }
        return url
    }
    
    func object(url: URL) -> CacheableObject<Value>? {
        var result: CacheableObject<Value>?
        if fileManager.fileExists(atPath: getFilePath(url: url)) {
            do {
                let data = try Data(contentsOf: getFileURL(url: url))
                result = try JSONDecoder().decode(
                    CacheableObject<Value>.self,
                    from: data
                )
            } catch {
                Logger.error(error)
            }
        }
        return result
    }
    
    func setObject(_ object: CacheableObject<Value>, url: URL) {
        do {
            let data = try JSONEncoder().encode(object)
            if !fileManager.fileExists(atPath: cacheDirectoryURL.path) {
                try fileManager.createDirectory(
                    at: cacheDirectoryURL,
                    withIntermediateDirectories: true
                )
            }
            fileManager.createFile(
                atPath: getFilePath(url: url),
                contents: data
            )
        } catch {
            Logger.error(error)
        }
    }
    
    private func getFileURL(url: URL) -> URL {
        cacheDirectoryURL.appendingPathComponent(url.lastPathComponent)
    }
    
    private func getFilePath(url: URL) -> String {
        let url = getFileURL(url: url)
        return if #available(iOS 16.0, *) {
            url.path()
        } else {
            url.path
        }
    }
}
