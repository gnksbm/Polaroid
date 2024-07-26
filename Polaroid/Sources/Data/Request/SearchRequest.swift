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
    let color: ColorOption?
    
    init(
        keyword: String,
        page: Int,
        countForPage: Int = 20,
        sortOption: SortOption,
        color: ColorOption?
    ) {
        self.keyword = keyword
        self.page = page
        self.countForPage = countForPage
        self.sortOption = sortOption
        self.color = color
    }
}
