//
//  RegexValidator.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import Foundation

protocol RegexValidator {
    associatedtype Regex: InvalidRegex
}

extension RegexValidator {
    func validate(input: String) throws {
        try Regex.allCases.forEach {
            let regex = try NSRegularExpression(pattern: $0.rawValue)
            let checkingResults = regex.matches(
                in: input,
                range: NSRange(input.startIndex..., in: input)
            )
            guard checkingResults.isEmpty else {
                throw $0.makeError(
                    input: input,
                    ranges: checkingResults.map { $0.range }
                )
            }
        }
    }
    
    func fix(input: String) -> String {
        var result = input
        Regex.allCases.forEach {
            result = $0.fix(input: result)
        }
        return result
    }
}

protocol InvalidRegex: CaseIterable, RawRepresentable where RawValue == String {
    associatedtype InputError: LocalizedError
    
    func makeError(input: String, ranges: [NSRange]) -> InputError
    func fix(input: String) -> String
}

extension InvalidRegex {
    func fix(input: String) -> String {
        input.replacingOccurrences(
            of: rawValue,
            with: "",
            options: .regularExpression
        )
    }
}

extension String {
    func validate<T: RegexValidator>(validator: T) throws {
        try validator.validate(input: self)
    }
    
    func fix<T: RegexValidator>(validator: T) -> String {
        validator.fix(input: self)
    }
    
}
