//
//  CircleButton.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

import SnapKit

class CircleButton: BaseButton {
    private let dimension: UIView.Dimension
    
    init(
        dimension: UIView.Dimension,
        padding: CGFloat = 0
    ) {
        self.dimension = dimension
        super.init()
        configureView(padding: padding)
    }
    
    private func configureView(padding: CGFloat) {
        configuration = .plain()
        configuration?.contentInsets = .same(size: padding)
        clipsToBounds = true
        
        snp.makeConstraints { make in
            make.width.equalTo(snp.height)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        applyCornerRadius(demension: .size(rect.width / 2))
    }
}
