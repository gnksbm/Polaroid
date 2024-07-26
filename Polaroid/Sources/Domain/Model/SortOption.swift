//
//  SortOption.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

enum SortOption: String, CaseIterable {
    case latest, relevant
}

extension SortOption {
    var title: String {
        switch self {
        case .latest:
            "최신순"
        case .relevant:
            "관련순"
        }
    }
}
