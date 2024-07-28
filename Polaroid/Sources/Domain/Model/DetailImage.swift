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
    let creatorProfileImageLocalPath: URL?
    let creatorName: String
    let createAt: Date?
    let imageURL: URL?
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let views: Statistics
    let download: Statistics
    
    struct Statistics: Hashable {
        let total: Int
        let chartData: [StatisticsData]
    }
    
    struct StatisticsData: Hashable {
        let date: String
        let value: Int
    }
}
