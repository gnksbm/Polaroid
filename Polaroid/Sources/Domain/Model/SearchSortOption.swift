//
//  SearchSortOption.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

enum SearchSortOption: String, CaseIterable {
    case latest, relevant
}

extension SearchSortOption {
    var title: String {
        switch self {
        case .latest:
            "최신순"
        case .relevant:
            "관련순"
        }
    }
}
