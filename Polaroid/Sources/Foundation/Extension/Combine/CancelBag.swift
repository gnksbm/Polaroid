//
//  CancelBag.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine

typealias CancelBag = Set<AnyCancellable>

extension CancelBag {
    mutating func cancel() {
        forEach {
            $0.cancel()
        }
        removeAll()
    }
}
