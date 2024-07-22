//
//  MPDesign.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

enum MPDesign { }

extension MPDesign {
    enum Font {
        static let heading = UIFont.systemFont(ofSize: 20)
        static let subtitle1 = UIFont.systemFont(ofSize: 19)
        static let subtitle2 = UIFont.systemFont(ofSize: 18)
        static let body1 = UIFont.systemFont(ofSize: 17)
        static let body2 = UIFont.systemFont(ofSize: 16)
        static let label1 = UIFont.systemFont(ofSize: 15)
        static let label2 = UIFont.systemFont(ofSize: 14)
        static let caption = UIFont.systemFont(ofSize: 13)
    }
}

extension MPDesign {
    enum Color {
        static let black = UIColor.mpBlack
        static let white = UIColor.mpWhite
        static let tint = UIColor.mpTint
        static let gray = UIColor.mpGray
        static let lightGray = UIColor.mpLightGray
        static let darkGray = UIColor.mpDarkGray
        static let red = UIColor.mpRed
        static let clear = UIColor.clear
    }
}
