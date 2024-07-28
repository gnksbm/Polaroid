//
//  StatisticsDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

struct StatisticsDTO: Codable {
    let id: String
    let downloads, views: Downloads
}

extension StatisticsDTO {
    func toDetailImage<T: MinimumImageData>(with data: T) -> DetailImage {
        DetailImage(
            id: id,
            creatorProfileImageURL: data.creatorProfileImageURL,
            creatorProfileImageLocalPath: data.creatorProfileImageLocalPath,
            creatorName: data.creatorName,
            createdAt: data.createdAt,
            imageURL: data.imageURL,
            imageWidth: data.imageWidth,
            imageHeight: data.imageHeight,
            views: DetailImage.Statistics(
                total: views.total,
                chartData: views.historical.values.map {
                    DetailImage.StatisticsData(date: $0.date, value: $0.value)
                }
            ),
            download: DetailImage.Statistics(
                total: downloads.total,
                chartData: downloads.historical.values.map {
                    DetailImage.StatisticsData(date: $0.date, value: $0.value)
                }
            )
        )
    }
}

extension StatisticsDTO {
    struct Downloads: Codable {
        let total: Int
        let historical: Historical
    }
    
    struct Historical: Codable {
        let values: [Value]
    }
    
    struct Value: Codable {
        let date: String
        let value: Int
    }
}
