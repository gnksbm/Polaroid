//
//  FavoriteSortOption.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

enum FavoriteSortOption: String, CaseIterable, SortOption {
    static var firstCase: FavoriteSortOption { .latest }
    
    case latest, oldest
}

extension FavoriteSortOption {
    var title: String {
        switch self {
        case .latest:
            "최신순"
        case .oldest:
            "과거순"
        }
    }
}
