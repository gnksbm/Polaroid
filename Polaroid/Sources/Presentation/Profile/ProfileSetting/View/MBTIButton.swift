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
    
    override init(dimension: CircleButton.Dimension, padding: CGFloat = 15) {
        super.init(dimension: dimension, padding: padding)
        bindColor()
        
        tapEvent
            .asObservable()
            .map { [weak self] button in
                guard let self else { return false }
                return !selectedState.value()
            }
            .bind(to: selectedState)
            .store(in: &observableBag)
    }
}
