//
//  ToggleView.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

protocol ToggleView: AnyObject {
    var selectedState: Observable<Bool> { get }
    var observableBag: ObservableBag { get set }
    
    var foregroundColor: UIColor? { get set }
    
    var normalForegroundColor: UIColor? { get }
    var normalBackgroundColor: UIColor? { get }
    var normalBorderColor: UIColor? { get }
    
    var selectedForegroundColor: UIColor? { get }
    var selectedBackgroundColor: UIColor? { get }
    var selectedBorderColor: UIColor? { get }
    
    func bindColor()
    func updateView(isSelected: Bool)
}

extension ToggleView where Self: UIView {
    var foregroundColor: UIColor? {
        get { nil }
        set { }
    }
    
    var normalForegroundColor: UIColor? { nil }
    var normalBackgroundColor: UIColor? { nil }
    var normalBorderColor: UIColor? { nil }
    
    var selectedForegroundColor: UIColor? { nil }
    var selectedBackgroundColor: UIColor? { nil }
    var selectedBorderColor: UIColor? { nil }
    
    func bindColor() {
        selectedState
            .bind { [weak self] isSelected in
                self?.updateView(isSelected: isSelected)
            }
            .store(in: &observableBag)
 
        foregroundColor = normalForegroundColor
        backgroundColor = normalBackgroundColor
        if let normalBorderColor {
            layer.borderColor = normalBorderColor.cgColor
            layer.borderWidth = 1
        }
    }
    
    func updateView(isSelected: Bool) {
        if isSelected {
            foregroundColor = selectedForegroundColor
            backgroundColor = selectedBackgroundColor
            layer.borderColor = selectedBorderColor?.cgColor
        } else {
            foregroundColor = normalForegroundColor
            backgroundColor = normalBackgroundColor
            layer.borderColor = normalBorderColor?.cgColor
        }
    }
}
