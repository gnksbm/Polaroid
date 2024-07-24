//
//  TopicSection.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import Foundation

enum TopicSection: CaseIterable {
    case goldenHour, architectureInterior, businessWork
    
    var title: String {
        switch self {
        case .goldenHour:
            "골든 아워"
        case .architectureInterior:
            "건축 및 인테리어"
        case .businessWork:
            "비즈니스 및 업무"
        }
    }
    
    var requestQuery: String {
        switch self {
        case .goldenHour:
            "golden-hour"
        case .architectureInterior:
            "architecture-interior"
        case .businessWork:
            "business-work"
        }
    }
}
