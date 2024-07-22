//
//  UIFont+.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

extension UIFont {
    func with(weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}
