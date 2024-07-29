//
//  ObservableControlEvent.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit

class ObservableControlEvent<Control: UIControl> {
    let control: Control
    let event: Control.Event
    var handler: ((Control) -> Void)?
    
    init(
        control: Control,
        event: UIControl.Event
    ) {
        self.control = control
        self.event = event
        control.addTarget(
            self,
            action: #selector(handleEvent),
            for: event
        )
    }
    
    @objc private func handleEvent(_ sender: UIControl) {
        if let control = sender as? Control {
            handler?(control)
        }
    }
    
    func bind(_ block: @escaping (Control) -> Void) -> Self {
        handler = block
        return self
    }
    
    func asObservable() -> Observable<Control> {
        let observable = Observable(control)
        bind { control in
            observable.onNext(control)
        }
        .store(in: &observable.eventBag)
        return observable
    }
    
    func store(in bag: inout ObservableBag) {
        bag.insert(self)
    }
}

extension ObservableControlEvent: Hashable {
    static func == (
        lhs: ObservableControlEvent,
        rhs: ObservableControlEvent
    ) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
