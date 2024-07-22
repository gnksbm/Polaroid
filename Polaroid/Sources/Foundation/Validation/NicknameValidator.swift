//
//  NicknameValidator.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import Foundation

struct NicknameValidator: RegexValidator {
    enum Regex: String, InvalidRegex {
        case rangeExpression = "^.{0,1}$|^.{10,}$"
        case containNum = "[0-9]"
        case specialCharacters = "[@#$%]"
        case prefixWhiteSpace = "^\\s"
        case suffixWhiteSpace = "\\s$"
        
        func makeError(input: String, ranges: [NSRange]) -> InputError {
            switch self {
            case .rangeExpression:
                return InputError.outOfRange
            case .containNum:
                return InputError.containNumber
            case .specialCharacters:
                let invalidWords = ranges.compactMap {
                    if let range = Range($0, in: input) {
                        String(input[range])
                    } else {
                        nil
                    }
                }
                return InputError.invalidWord(invalidWords)
            case .prefixWhiteSpace:
                return InputError.prefixWhiteSpace
            case .suffixWhiteSpace:
                return InputError.suffixWhiteSpace
            }
        }
        
        func fix(input: String) -> String {
            switch self {
            case .rangeExpression:
                if input.count < 2 {
                    var result = input
                    while result.count < 2 {
                        result += "⭐️"
                    }
                    return result
                } else if input.count > 9 {
                    return String(input.prefix(9))
                } else {
                    return input
                }
            case .prefixWhiteSpace:
                var result = input
                while result.hasPrefix(" ") {
                    result.removeFirst()
                }
                return result
            case .suffixWhiteSpace:
                var result = input
                while result.hasSuffix(" ") {
                    result.removeLast()
                }
                return result
            default:
                return input.replacingOccurrences(
                    of: rawValue,
                    with: "",
                    options: .regularExpression
                )
            }
        }
    }
    
    enum InputError: LocalizedError, Equatable {
        case outOfRange
        case containNumber
        case invalidWord([String])
        case prefixWhiteSpace
        case suffixWhiteSpace
        
        var errorDescription: String? {
            switch self {
            case .outOfRange:
                Literal.Nickname.outOfRange
            case .containNumber:
                Literal.Nickname.containNumber
            case .invalidWord(let words):
                Literal.Nickname.invalidWord(words: words)
            case .prefixWhiteSpace:
                Literal.Nickname.prefixWhiteSpace
            case .suffixWhiteSpace:
                Literal.Nickname.suffixWhiteSpace
            }
        }
    }
}
