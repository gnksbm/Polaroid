//
//  NetworkMonitor.swift
//  Polaroid
//
//  Created by gnksbm on 7/29/24.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue: DispatchQueue
    
    private init(
        queue: DispatchQueue = DispatchQueue(
            label: "NetworkMonitor",
            qos: .utility
        )
    ) {
        self.queue = queue
    }
    
    func start(_ handler: @escaping (NWPath) -> Void) {
        monitor.pathUpdateHandler = { path in
            handler(path)
        }
        monitor.start(queue: queue)
    }
    
    func stop() {
        monitor.cancel()
    }
}
