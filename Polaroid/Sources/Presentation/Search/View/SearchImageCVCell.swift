//
//  SearchImageCVCell.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import UIKit

typealias SearchColorOption = SearchRequest.Color

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

enum SearchCVItem: Hashable {
    case color(selectedColor: SearchColorOption), image
}

final class SearchImageCVCell: UICollectionViewCell, RegistrableCellType {
    static func makeRegistration() -> Registration<SearchCVItem> {
        Registration { cell, indexPath, item in
            switch item {
            case .color(let selectedColor):
                break
            case .image:
                break
            }
        }
    }
}

