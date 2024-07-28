//
//  StatisticsDTO.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

struct StatisticsDTO: Codable {
    let id, slug: String
    let downloads, views, likes: Downloads
}

extension StatisticsDTO {
    struct Downloads: Codable {
        let total: Int
        let historical: Historical
    }
    
    struct Historical: Codable {
        let change: Int
        let resolution: String
        let quantity: Int
        let values: [Value]
    }
    
    struct Value: Codable {
        let date: String
        let value: Int
    }
}
