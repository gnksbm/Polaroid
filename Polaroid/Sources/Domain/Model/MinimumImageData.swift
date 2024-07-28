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
    var creatorProfileImageLocalPath: URL? { get }
    var creatorName: String { get }
    var createAt: Date? { get }
    var imageURL: URL? { get }
    var imageWidth: CGFloat { get }
    var imageHeight: CGFloat { get }
}
