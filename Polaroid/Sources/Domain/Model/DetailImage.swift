//
//  DetailImage.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

struct DetailImage: Hashable {
    let id: String
    let creatorProfileImageURL: URL?
    var creatorProfileImageLocalPath: String?
    let creatorName: String
    let createdAt: Date?
    let imageURL: URL?
    var localURL: String?
    var isLiked: Bool
    let imageWidth: Int
    let imageHeight: Int
    var views: Statistics?
    var download: Statistics?
    
    struct Statistics: Hashable {
        let total: Int
        let chartData: [StatisticsData]
    }
    
    struct StatisticsData: Hashable {
        let date: String
        let value: Int
    }
    
    init(
        id: String,
        creatorProfileImageURL: URL?,
        creatorProfileImageLocalPath: String? = nil,
        creatorName: String,
        createdAt: Date?,
        imageURL: URL?,
        localURL: String? = nil,
        isLiked: Bool,
        imageWidth: Int,
        imageHeight: Int,
        views: Statistics? = nil,
        download: Statistics? = nil
    ) {
        self.id = id
        self.creatorProfileImageURL = creatorProfileImageURL
        self.creatorProfileImageLocalPath = creatorProfileImageLocalPath
        self.creatorName = creatorName
        self.createdAt = createdAt
        self.imageURL = imageURL
        self.localURL = localURL
        self.isLiked = isLiked
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.views = views
        self.download = download
    }
    
    init<T: MinimumImageData>(minImageData: T) {
        self.id = minImageData.id
        self.creatorProfileImageURL = minImageData.creatorProfileImageURL
        self.creatorProfileImageLocalPath = minImageData.creatorProfileImageLocalPath
        self.creatorName = minImageData.creatorName
        self.createdAt = minImageData.createdAt
        self.imageURL = minImageData.imageURL
        self.localURL = minImageData.localURL
        self.isLiked = minImageData.isLiked
        self.imageWidth = minImageData.imageWidth
        self.imageHeight = minImageData.imageHeight
        self.views = nil
        self.download = nil
    }
}
