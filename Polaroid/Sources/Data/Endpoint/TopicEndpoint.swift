//
//  TopicEndpoint.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

struct TopicEndpoint: UnsplashEndpoint {
    let request: TopicRequest
    
    var path: String { "/topics/\(request.topicID)/photos" }
    var queries: [String : String]? { ["page": "\(request.page)"] }
}
