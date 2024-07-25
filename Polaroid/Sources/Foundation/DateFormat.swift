//
//  DateFormat.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

enum DateFormat: String {
    case createdAt = "yyyy년 M월 d일 게시됨"
}

extension DateFormat {
    private static var cachedStorage = [DateFormat: DateFormatter]()
    
    var formatter: DateFormatter {
        if let formatter = Self.cachedStorage[self] {
            return formatter
        } else {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = rawValue
            newFormatter.locale = Locale(identifier: "ko_KR")
            Self.cachedStorage[self] = newFormatter
            return newFormatter
        }
    }
}

extension String {
    func formatted(dateFormat: DateFormat) -> Date? {
        dateFormat.formatter.date(from: self)
    }
    
    func formatted(input: DateFormat, output: DateFormat) -> String? {
        input.formatter.date(from: self)?.formatted(dateFormat: output)
    }
    
    func iso8601Formatted() -> Date? {
        ISO8601DateFormatter.shared.date(from: self)
    }
}

extension Date {
    func formatted(dateFormat: DateFormat) -> String {
        dateFormat.formatter.string(from: self)
    }
}

extension ISO8601DateFormatter {
    static let shared = ISO8601DateFormatter()
}
