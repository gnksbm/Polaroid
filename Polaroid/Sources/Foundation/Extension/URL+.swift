//
//  URL+.swift
//  Polaroid
//
//  Created by gnksbm on 7/29/24.
//

import Foundation

extension URL {
    var currentPath: String {
        if #available(iOS 16.0, *) {
            path()
        } else {
            path
        }
    }
}
