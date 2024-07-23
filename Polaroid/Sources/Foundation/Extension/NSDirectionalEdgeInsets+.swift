//
//  NSDirectionalEdgeInsets+.swift
//  Polaroid
//
//  Created by gnksbm on 7/23/24.
//

import UIKit

extension NSDirectionalEdgeInsets {
    static func same(size: CGFloat) -> Self {
        NSDirectionalEdgeInsets(
            top: size,
            leading: size,
            bottom: size,
            trailing: size
        )
    }
}
