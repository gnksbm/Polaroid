//
//  MBTIButton.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

final class MBTIButton: CircleButton, ToggleView {
    var selectedState = Observable<Bool>(false)
    var observableBag = ObservableBag()
    
    var foregroundColor: UIColor? {
        get {
            tintColor
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    var normalForegroundColor: UIColor? { MPDesign.Color.gray }
    var normalBackgroundColor: UIColor? { MPDesign.Color.white }
    var normalBorderColor: UIColor? { MPDesign.Color.gray }
    
    var selectedForegroundColor: UIColor? { MPDesign.Color.white }
    var selectedBackgroundColor: UIColor? { MPDesign.Color.tint }
    var selectedBorderColor: UIColor? { MPDesign.Color.clear }
    
    override init(dimension: CircleButton.Dimension) {
        super.init(dimension: dimension)
        bindColor()
    }
}
