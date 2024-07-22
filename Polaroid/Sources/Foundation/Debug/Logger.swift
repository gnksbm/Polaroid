//
//  Logger.swift
//  Polaroid
//
//  Created by gnksbm on 7/22/24.
//

import Foundation
import OSLog

extension String {
    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "Polaroid"
}

enum Logger {
    private static var logger = OSLog(
        subsystem: .bundleIdentifier,
        category: "Default"
    )
    
    static func debug(
        _ content: Any,
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) {
        os_log(
            """
            📍 %{public}@ at line %{public}d - %{public}@ 📍
            🔵 %{public}@ 🔵
            """,
            log: logger,
            type: .debug,
            file, line, function, String(describing: content)
        )
    }
    
    static func error(
        _ error: Error,
        with: Any? = nil,
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) {
        if let with {
            os_log(
                """
                📍 %{public}@ at line %{public}d - %{public}@ 📍
                🔴 %{public}@
                %{public}@ 🔴
                """,
                log: logger,
                type: .error,
                file, line, function, String(describing: error),
                String(describing: with)
            )
        } else {
            os_log(
                """
                📍 %{public}@ at line %{public}d - %{public}@ 📍
                🔴 %{public}@ 🔴
                """,
                log: logger,
                type: .error,
                file, line, function, String(describing: error)
            )
        }
    }
    
    static func retainCount(
        _ target: AnyObject,
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) {
        let retainCount = CFGetRetainCount(target) - 1
        os_log(
            """
            📍 %{public}@ at line %{public}d - %{public}@ 📍
            ➡️ %{public}@'s Retain Count: %{public}ld ⬅️
            """,
            log: logger,
            type: .debug,
            file, line, function, String(describing: target), retainCount
        )
    }
    
    static func nilObject<T: AnyObject, U>(
        _ target: T,
        keyPath: KeyPath<T, U>,
        file: String = #fileID,
        line: Int = #line,
        function: String = #function
    ) {
        let parentType = removingOptionalDescription(type: T.self)
        let propertyType = removingOptionalDescription(type: U.self)
        
        os_log(
            """
            Location: %{public}@ at line %{public}d.
            %{public}@'s %{public}@ is nil.
            """,
            log: logger,
            type: .error,
            file, line, parentType, propertyType
        )
    }
    
    private static func removingOptionalDescription(type: Any.Type) -> String {
        String(describing: type)
            .replacingOccurrences(of: "Optional<", with: "")
            .replacingOccurrences(of: ">", with: "")
    }
}


