//
//  StatisticsEndpoint.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

struct StatisticsEndpoint: UnsplashEndpoint {
    let request: StatisticsRequest
    
    var path: String { "/photos/\(request.imageID)/statistics" }
}
