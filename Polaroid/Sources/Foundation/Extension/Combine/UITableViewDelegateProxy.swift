//
//  UITableViewDelegateProxy.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Combine
import UIKit

struct UITableViewDelegateProxy<TableView: UITableView>: Publisher {
    typealias Output = IndexPath
    typealias Failure = Never
    
    let tableView: TableView
    
    init(_ tableView: TableView) {
        self.tableView = tableView
    }
    
    func receive<S>(
        subscriber: S
    ) where S : Subscriber, Never == S.Failure, IndexPath == S.Input {
        subscriber.receive(
            subscription: UITableViewDelegateSubscrioption(
                subscriber: subscriber,
                tableView: tableView
            )
        )
    }
}

class UITableViewDelegateSubscrioption
<S: Subscriber<IndexPath, Never>, TableView: UITableView>: NSObject, UITableViewDelegate, Subscription {
    var subscriber: S?
    var demand: Subscribers.Demand = .none
    
    init(subscriber: S, tableView: TableView) {
        self.subscriber = subscriber
        super.init()
        tableView.delegate = self
    }
    
    func request(_ demand: Subscribers.Demand) {
        self.demand += demand
    }
    
    func cancel() {
        subscriber = nil
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard demand > .none else { return }
        demand -= .max(1)
        _ = subscriber?.receive(indexPath)
    }
}
