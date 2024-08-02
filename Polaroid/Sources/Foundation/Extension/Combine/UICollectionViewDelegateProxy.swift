//
//  UICollectionViewDelegateProxy.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine
import UIKit

struct UICollectionViewDelegateProxy: Publisher {
    typealias Output = IndexPath
    typealias Failure = Never
    
    let collectionView: UICollectionView
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func receive<S>(
        subscriber: S
    ) where S : Subscriber, Never == S.Failure, IndexPath == S.Input {
        subscriber.receive(
            subscription: UICollectionViewDelegateSubscription(
                subscriber: subscriber,
                collectionView: collectionView
            )
        )
    }
}

class UICollectionViewDelegateSubscription<S: Subscriber<IndexPath, Never>>:
    NSObject, UICollectionViewDelegate, Subscription {
    var subscriber: S?
    var demand: Subscribers.Demand = .none
    
    init(subscriber: S, collectionView: UICollectionView) {
        self.subscriber = subscriber
        super.init()
        collectionView.delegate = self
    }
    
    func request(_ demand: Subscribers.Demand) {
        self.demand += demand
    }
    
    func cancel() {
        subscriber = nil
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard demand > .none else { return }
        demand -= .max(1)
        _ = subscriber?.receive(indexPath)
    }
}
