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
    
    mutating func insert(
        @CancellableBuilder _ cancellables: () -> [AnyCancellable]
    ) {
        cancellables().forEach { insert($0) }
    }
    
    @resultBuilder
    enum CancellableBuilder {
        static func buildBlock(
            _ components: AnyCancellable...
        ) -> [AnyCancellable] {
            components
        }
    }
}
