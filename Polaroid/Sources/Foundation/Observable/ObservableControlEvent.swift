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
    
    func bind(_ block: @escaping (Control) -> Void) {
        handler = block
    }
    
    func asObservable() -> Observable<Control> {
        let observable = Observable(control)
        handler = { control in
            observable.onNext(control)
        }
        return observable
    }
}
