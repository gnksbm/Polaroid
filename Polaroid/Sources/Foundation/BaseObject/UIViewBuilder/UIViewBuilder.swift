//
//  UIViewBuilder.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

@resultBuilder
enum UIViewBuilder {
    static func buildBlock(_ components: UIView...) -> [UIView] {
        components
    }
    
    static func buildBlock(_ components: [UIView]...) -> [UIView] {
        components.flatMap { $0 }
    }
}
