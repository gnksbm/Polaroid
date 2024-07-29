//
//  UnsplashSearchValidator.swift
//  Polaroid
//
//  Created by gnksbm on 7/29/24.
//

import Foundation

struct UnsplashSearchValidator: RegexValidator {
    enum Regex: String, InvalidRegex {
        case onlyWhiteSpace = "^\\s+$"
        case isEmpty = "^$"
        
        func makeError(input: String, ranges: [NSRange]) -> InputError {
            switch self {
            case .onlyWhiteSpace:
                return .onlyWhiteSpace
            case .isEmpty:
                return .isEmpty
            }
        }
    }
    
    enum InputError: LocalizedError, Equatable {
        case onlyWhiteSpace, isEmpty
        
        var errorDescription: String? {
            switch self {
            case .onlyWhiteSpace:
                "공백으로만 검색할 수 없습니다"
            case .isEmpty:
                "검색어를 입력해 주세요"
            }
        }
    }
}
