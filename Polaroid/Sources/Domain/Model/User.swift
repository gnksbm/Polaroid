//
//  User.swift
//  Polaroid
//
//  Created by gnksbm on 7/29/24.
//

import Foundation

struct User: Codable {
    let profileImageData: Data
    let name: String
    let mbti: MBTI
}
