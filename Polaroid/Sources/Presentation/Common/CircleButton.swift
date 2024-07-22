//
//  CircleButton.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

class CircleButton: BaseButton {
    private let dimension: Dimension
    
    init(
        dimension: Dimension
    ) {
        self.dimension = dimension
        super.init()
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat
        switch dimension {
        case .width:
            size = bounds.width
        case .height:
            size = bounds.height
        case .size(let value):
            size = value
        }
        let origin = bounds.origin
        bounds = .init(
            origin: origin,
            size: .init(
                width: size,
                height: size
            )
        )
        layer.cornerRadius = size / 2
    }
}

extension CircleButton {
    public enum Dimension {
        case width, height, size(CGFloat)
    }
}
