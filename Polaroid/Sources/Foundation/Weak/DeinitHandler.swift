//
//  DeinitHandler.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation

final class DeinitHandler {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    deinit {
        action()
    }
}
