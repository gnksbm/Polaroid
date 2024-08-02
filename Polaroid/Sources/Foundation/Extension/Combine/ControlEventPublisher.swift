//
//  ControlEventPublisher.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import UIKit
import Combine

struct ControlEventPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never
    
    let control: Control
    let event: Control.Event
    
    func receive<S>(
        subscriber: S
    ) where S : Subscriber, Never == S.Failure, Control == S.Input {
        subscriber.receive(
            subscription: ControlSubscription(
                subscriber: subscriber,
                control: control,
                event: event
            )
        )
    }
}
