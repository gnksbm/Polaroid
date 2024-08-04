//
//  ProfileImageButton.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import Combine
import UIKit

final class ProfileImageButton: CircleButton, ToggleView {
    var selectedState = CurrentValueSubject<Bool, Never>(false)
    var cancelBag = CancelBag()
    
    var normalBorderColor: UIColor? { MPDesign.Color.gray }
    
    var selectedBorderColor: UIColor? { MPDesign.Color.tint }
    
    init(
        type: ViewType,
        dimension: CircleButton.Dimension
    ) {
        super.init(dimension: dimension)
        configuration = nil
        imageView?.contentMode = .scaleAspectFit
        switch type {
        case .static:
            updateView(isSelected: true)
            layer.borderWidth = MPDesign.BorderSize.large
            alpha = 1
        case .dynamic:
            bindColor()
            isEnabled = true
            selectedState
                .sink { [weak self] isSelected in
                    self?.layer.borderWidth = isSelected ?
                    MPDesign.BorderSize.large : MPDesign.BorderSize.small
                    self?.alpha = isSelected ? 1 : 0.5
                }
                .store(in: &cancelBag)
        }
    }
}

extension ProfileImageButton {
    enum ViewType {
        case `static`, dynamic
    }
}
