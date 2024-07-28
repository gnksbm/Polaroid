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
}
