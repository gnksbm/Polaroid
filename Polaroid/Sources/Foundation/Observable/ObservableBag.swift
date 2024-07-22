//
//  ObservableBag.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

typealias ObservableBag = Set<AnyHashable>

extension ObservableBag {
    mutating func cancel() {
        removeAll()
    }
}
