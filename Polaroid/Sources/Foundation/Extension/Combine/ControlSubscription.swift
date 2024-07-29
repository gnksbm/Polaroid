//
//  ControlSubscription.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//
/*
import UIKit
import Combine

final class ControlSubscription
<S: Subscriber<Control, Never>, Control: UIControl>: Subscription {
    var subscriber: S?
    let control: Control
    var demand: Subscribers.Demand = .none
    
    init(subscriber: S?, control: Control, event: Control.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(handler), for: event)
    }
    
    func request(_ demand: Subscribers.Demand) {
        self.demand += demand
    }
    
    func cancel() {
        subscriber = nil
    }
    
    @objc private func handler() {
        guard demand > .none else { return }
        demand -= .max(1)
        _ = subscriber?.receive(control)
    }
}
*/
