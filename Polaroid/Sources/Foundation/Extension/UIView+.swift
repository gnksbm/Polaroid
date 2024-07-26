//
//  UIView+.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//

import UIKit

extension UIView {
    func applyCornerRadius(demension: Dimension) {
        layer.cornerRadius = switch demension {
        case .width:
            bounds.width
        case .height:
            bounds.height
        case .size(let value):
            value
        }
    }
    
    enum Dimension {
        case width, height, size(CGFloat)
    }
}
