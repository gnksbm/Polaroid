//
//  Literal.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

enum Literal {
    enum Onboarding {
        static let name = "김건섭"
    }
    
    enum MBTI {
        static let title = "MBTI"
    }
    
    enum Nickname {
        static let placeholder = "닉네임을 입력해주세요"
        static let validationSuccess = "사용할 수 있는 닉네임이에요"
        static let outOfRange = "2글자 이상 10글자 미만으로 설정해주세요"
        static let containNumber = "닉네임에 숫자는 포함할 수 없어요"
        static func invalidWord(words: [String]) -> String {
            let invalidWord = words.joined(separator: ", ")
            return "닉네임에 \(invalidWord) 는 포함할 수 없어요"
        }
        static let prefixWhiteSpace = "닉네임은 공백으로 시작할 수 없어요"
        static let suffixWhiteSpace = "닉네임은 공백으로 끝날 수 없어요"
    }
    
    enum Search {
        static let searchBarPlaceholder = "키워드 검색"
        static let beforeSearchBackground = "사진을 검색해보세요."
        static let emptyResultBackground = "검색 결과가 없어요."
    }
    
    enum Favorite {
        static let emptyResultBackground = "저장된 사진이 없어요."
    }
    
    enum NavigationTitle {
        static let profileStrring = "PROFILE SETTING"
        static let ourTopic = "OUT TOPIC"
        static let search = "SEARCH PHOTO"
        static let favorite = "MY POLAROID"
    }
    
    enum Image {
        static let defaultProfileList = [
            UIImage.profile0,
            UIImage.profile1,
            UIImage.profile2,
            UIImage.profile3,
            UIImage.profile4,
            UIImage.profile5,
            UIImage.profile6,
            UIImage.profile7,
            UIImage.profile8,
            UIImage.profile9,
            UIImage.profile10,
            UIImage.profile11,
        ]
    }
}
