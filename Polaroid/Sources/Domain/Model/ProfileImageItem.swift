//
//  ProfileImageItem.swift
//  Polaroid
//
//  Created by gnksbm on 7/24/24.
//

import UIKit

struct ProfileImageItem: Hashable {
    let image: UIImage?
    let isSelected: Bool
    
    init(
        image: UIImage?,
        isSelected: Bool = false
    ) {
        self.image = image
        self.isSelected = isSelected
    }
}

extension Array where Element == ProfileImageItem {
    init(images: [UIImage], selectedImage: UIImage?) {
        self = images.map {
            ProfileImageItem(image: $0, isSelected: $0 == selectedImage)
        }
    }
}
