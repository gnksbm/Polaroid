//
//  BaseStackView.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

class BaseStackView: UIStackView {
    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() { }
    func configureLayout() { }
}
