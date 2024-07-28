//
//  RandomEndpoint.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

struct RandomEndpoint: UnsplashEndpoint {
    var path: String { "/photos/random" }
    var queries: [String : String] {
        ["count": "10"]
    }
}
