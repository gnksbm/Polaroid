//
//  Throttle.swift
//  Polaroid
//
//  Created by gnksbm on 7/26/24.
//
/*
import Foundation

final class Throttle {
    private let period: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue

    init(period: TimeInterval, queue: DispatchQueue = .main) {
        self.period = period
        self.queue = queue
    }

    func run(action: @escaping () -> Void) {
        if workItem == nil {
            action()
            let workItem = DispatchWorkItem {
                self.workItem?.cancel()
                self.workItem = nil
            }
            self.workItem = workItem
            queue.asyncAfter(deadline: .now() + period, execute: workItem)
        }
    }
}
*/
