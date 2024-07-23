//
//  Literal.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

enum Literal {
    enum Onboarding {
        static let name = "김건섭"
    }
    
    enum MBTI {
        static let title = "MBTI"
    }
    
    enum Nickname {
        static let validationSuccess = "사용할 수 있는 닉네임이에요"
        static let outOfRange = "2글자 이상 10글자 미만으로 설정해주세요"
        static let containNumber = "닉네임에 숫자는 포함할 수 없어요"
        static func invalidWord(words: [String]) -> String {
            let invalidWord = words.joined(separator: ", ")
            return "닉네임에 \(invalidWord) 는. 포할할 수 없어요"
        }
        static let prefixWhiteSpace = "닉네임은 공백으로 시작할 수 없어요"
        static let suffixWhiteSpace = "닉네임은 공백으로 끝날 수 없어요"
    }
    
    enum NavigationTitle {
        static let profileStrring = "PROFILE SETTING"
    }
}
