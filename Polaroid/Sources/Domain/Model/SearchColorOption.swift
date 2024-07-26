//
//  SearchColorOption.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import UIKit

enum SearchColorOption: String {
    case black, white, yellow, red, purple, green, blue
}

extension SearchColorOption {
    var title: String {
        switch self {
        case .black:
            "블랙"
        case .white:
            "화이트"
        case .yellow:
            "옐로우"
        case .red:
            "레드"
        case .purple:
            "퍼플"
        case .green:
            "그린"
        case .blue:
            "블루"
        }
    }
    
    var color: UIColor {
        switch self {
        case .black:
            MPDesign.Color.black
        case .white:
            MPDesign.Color.white
        case .yellow:
            MPDesign.Color.yellow
        case .red:
            MPDesign.Color.red
        case .purple:
            MPDesign.Color.purple
        case .green:
            MPDesign.Color.green
        case .blue:
            MPDesign.Color.blue
        }
    }
}
