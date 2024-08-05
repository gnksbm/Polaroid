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
    
    private var latestStatus = NWPath.Status.requiresConnection
    
    private init(
        queue: DispatchQueue = DispatchQueue(
            label: "NetworkMonitor",
            qos: .utility
        )
    ) {
        self.queue = queue
    }
    
    func startMonitoring(_ handler: @escaping (_ isConnected: Bool) -> Void) {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            if latestStatus != path.status {
                latestStatus = path.status
                handler(latestStatus == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
        latestStatus = NWPath.Status.requiresConnection
    }
}
