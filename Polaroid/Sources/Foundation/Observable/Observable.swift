//
//  Observable.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

final class Observable<Base> {
    private var handlers = [ObservableHandler<Base>]()
    
    private var base: Base {
        didSet {
            handlers.forEach { $0.receive(base) }
        }
    }
    
    init(_ base: Base) {
        self.base = base
    }
    
    func onNext(_ value: Base) {
        base = value
    }
    
    func bind(onNext: @escaping (Base) -> Void) {
        handlers.append(ObservableHandler<Base>(onNext))
    }
    
    func value() -> Base {
        base
    }
}

extension Observable: Hashable {
    static func == (lhs: Observable<Base>, rhs: Observable<Base>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

fileprivate final class ObservableHandler<Base> {
    private var handler: ((Base) -> Void)?
    
    init(_ handler: @escaping (Base) -> Void) {
        self.handler = handler
    }
    
    func receive(_ value: Base) {
        handler?(value)
    }
}
