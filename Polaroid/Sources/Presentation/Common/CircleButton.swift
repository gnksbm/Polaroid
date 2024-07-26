//
//  CircleButton.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

class CircleButton: BaseButton {
    private let dimension: UIView.Dimension
    
    init(
        dimension: UIView.Dimension
    ) {
        self.dimension = dimension
        super.init()
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadius(demension: dimension)
    }
}
