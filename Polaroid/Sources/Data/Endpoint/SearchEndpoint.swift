//
//  SearchEndpoint.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

struct SearchEndpoint: UnsplashEndpoint {
    let request: SearchRequest
    
    var path: String { "/search/photos" }
    var queries: [String : String]? {
        [
            "query": request.keyword,
            "page": "\(request.page)",
            "per_page": "\(request.countForPage)",
            "order_by": request.sortOption.rawValue,
            "color": request.color.rawValue
        ]
    }
}
