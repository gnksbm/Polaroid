//
//  DTOParseTests.swift
//  PolaroidTests
//
//  Created by gnksbm on 7/23/24.
//

import XCTest
@testable import Polaroid

final class DTOParseTests: XCTestCase {
    func testExample() throws {
        guard let url = Bundle.main.url(
            forResource: "Topic",
            withExtension: "json"
        ) else {
            XCTFail()
            return
        }
        XCTAssertNoThrow {
            let data = try Data(contentsOf: url)
            _ = try JSONDecoder().decode([TopicDTO].self, from: data)
        }
    }
}
