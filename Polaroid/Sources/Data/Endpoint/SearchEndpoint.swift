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
    var queries: [String : String] {
        var queries = [
            "query": request.keyword,
            "page": "\(request.page)",
            "per_page": "\(request.countForPage)",
            "order_by": request.sortOption.rawValue
        ]
        if let color = request.color?.rawValue {
            queries.merge(["color": color]) { $1 }
        }
        return queries
    }
}
