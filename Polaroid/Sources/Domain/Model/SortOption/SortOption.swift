//
//  SortOption.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import Foundation

protocol SortOption: RawRepresentable<String>, CaseIterable, Equatable where AllCases.Index == Int {
    var title: String { get }
    static var firstCase: Self { get }
}
