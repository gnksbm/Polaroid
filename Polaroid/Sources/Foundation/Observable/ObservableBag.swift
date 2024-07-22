//
//  ObservableBag.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

typealias ObservableBag = Set<Observable<Any>>

extension ObservableBag {
    mutating func cancel() {
        removeAll()
    }
}
