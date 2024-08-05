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
    
    func sink<Object: AnyObject>(
        with object: Object,
        receiveValue: @escaping (Object, Output) -> Void
    ) -> AnyCancellable where Failure == Never {
        compactMap { [weak object] output in
            guard let object else { return nil }
            return (object, output)
        }
        .sink(receiveValue: receiveValue)
    }
    
    func asCurrentValueSubject(
        default value: Output
    ) -> CurrentValueSubject<Output, Failure> {
        CurrentValueSubject<Output, Failure>(value)
    }
}
