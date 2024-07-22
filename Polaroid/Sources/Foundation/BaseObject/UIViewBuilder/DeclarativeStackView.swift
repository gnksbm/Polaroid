//
//  DeclarativeStackView.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

final class DeclarativeStackView: BaseStackView {
    init(
        axis: NSLayoutConstraint.Axis = .vertical,
        spacing: CGFloat = 20,
        distribution: UIStackView.Distribution = .equalSpacing,
        @UIViewBuilder subViews: () -> [UIView]
    ) {
        super.init()
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        subViews().forEach { addArrangedSubview($0) }
    }
}
