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
}

extension ToggleView where Self: UIButton {
    func bindColor() {
        tapEvent
            .asObservable()
            .map { [weak self] button in
                guard let self else { return false }
                return !selectedState.value()
            }
            .bind(to: selectedState)
            .store(in: &observableBag)
        
        selectedState
            .bind { [weak self] isSelected in
                guard let self else { return }
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
            .store(in: &observableBag)
 
        foregroundColor = normalForegroundColor
        backgroundColor = normalBackgroundColor
        layer.borderColor = normalBorderColor?.cgColor
        layer.borderWidth = 1
    }
}
