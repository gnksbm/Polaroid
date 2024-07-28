//
//  MinimumImageData.swift
//  Polaroid
//
//  Created by gnksbm on 7/28/24.
//

import Foundation

protocol MinimumImageData {
    var id: String { get }
    var creatorProfileImageURL: URL? { get }
    var creatorProfileImageLocalPath: String? { get }
    var creatorName: String { get }
    var createdAt: Date? { get }
    var imageURL: URL? { get }
    var imageWidth: Int { get }
    var imageHeight: Int { get }
}
