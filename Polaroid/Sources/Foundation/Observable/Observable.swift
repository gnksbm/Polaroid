//
//  Observable.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

final class Observable<Base> {
    var eventBag = ObservableBag()
    
    private var handlers = [ObservableHandler<Base>]()
    private var throttle: Throttle?
    private var base: Base {
        didSet {
            if let throttle {
                throttle.run { [weak self] in
                    guard let self else { return }
                    handlers.forEach { $0.receive(self.base) }
                }
            } else {
                handlers.forEach { $0.receive(base) }
            }
        }
    }
    
    init(_ base: Base) {
        self.base = base
    }
    
    func onNext(_ value: Base) {
        base = value
    }
    
    func bind(onNext: @escaping (Base) -> Void) -> Self {
        handlers.append(ObservableHandler<Base>(onNext))
        return self
    }
    
    func bind(to stream: Observable<Base>) -> Self {
        _ = bind { base in
            stream.onNext(base)
        }
        return self
    }
    
    func value() -> Base {
        base
    }
    
    func store(in bag: inout ObservableBag) {
        bag.insert(self)
    }
}

extension Observable {
    func map<T>(_ block: @escaping (Base) -> T) -> Observable<T> {
        let newBase = block(base)
        let newObservable = Observable<T>(newBase)
        _ = bind { base in
            newObservable.onNext(block(base))
        }
        return newObservable
    }
    
    func throttle(period: TimeInterval) -> Self {
        throttle = Throttle(period: period)
        return self
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
