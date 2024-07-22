//
//  BaseButton.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

class BaseButton: UIButton {
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
