//
//  SearchRequest.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

struct SearchRequest {
    let keyword: String
    let page: Int
    let countForPage: Int
    let sortOption: SortOption
    let color: Color?
    
    init(
        keyword: String,
        page: Int,
        countForPage: Int = 20,
        sortOption: SortOption,
        color: Color
    ) {
        self.keyword = keyword
        self.page = page
        self.countForPage = countForPage
        self.sortOption = sortOption
        self.color = color
    }
}

extension SearchRequest {
    enum SortOption: String {
        case latest, relevant
    }
    
    enum Color: String {
        case black, white, yellow, red, purple, green, blue
    }
}
