//
//  MBTIButton.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine
import UIKit

final class MBTIButton: CircleButton, ToggleView {
    var selectedState = CurrentValueSubject<Bool, Never>(false)
    var cancelBag = CancelBag()
    
    var foregroundColor: UIColor? {
        get {
            configuration?.baseForegroundColor
        }
        set {
            configuration?.baseForegroundColor = newValue
        }
    }
    
    var normalForegroundColor: UIColor? { MPDesign.Color.gray }
    var normalBackgroundColor: UIColor? { MPDesign.Color.white }
    var normalBorderColor: UIColor? { MPDesign.Color.gray }
    
    var selectedForegroundColor: UIColor? { MPDesign.Color.white }
    var selectedBackgroundColor: UIColor? { MPDesign.Color.tint }
    var selectedBorderColor: UIColor? { MPDesign.Color.clear }
    
    override init(dimension: CircleButton.Dimension, padding: CGFloat = 15) {
        super.init(dimension: dimension, padding: padding)
        bindColor()
    }
}
