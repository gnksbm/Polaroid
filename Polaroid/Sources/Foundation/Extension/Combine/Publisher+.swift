//
//  Publisher+.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine

extension Publisher {
    func withUnretained<Object: AnyObject>(
        _ object: Object
    ) -> Publishers.CompactMap<Self, (Object, Output)> {
        compactMap { [weak object] output in
            guard let object else { return nil }
            return (object, output)
        }
    }
}

