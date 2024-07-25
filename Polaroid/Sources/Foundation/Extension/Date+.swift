//
//  Date+.swift
//  Polaroid
//
//  Created by gnksbm on 7/25/24.
//

import Foundation

extension Date {
    init?(isoDateString: String) {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        if let date = isoFormatter.date(from: isoDateString) {
            self = date
        } else {
            return nil
        }
    }
}
