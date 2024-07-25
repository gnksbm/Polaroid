//
//  DTOParseTests.swift
//  PolaroidTests
//
//  Created by gnksbm on 7/23/24.
//

import XCTest
@testable import Polaroid

final class DTOParseTests: XCTestCase {
    func test_parse_topic() throws {
        guard let url = Bundle(for: type(of: self)).url(
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
    
    func test_parse_random() throws {
        guard let url = Bundle(for: type(of: self)).url(
            forResource: "Random",
            withExtension: "json"
        ) else {
            XCTFail()
            return
        }
        XCTAssertNoThrow {
            let data = try Data(contentsOf: url)
            _ = try JSONDecoder().decode([RandomDTO].self, from: data)
        }
    }
}
