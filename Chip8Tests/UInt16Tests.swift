//
//  UInt16Tests.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 19/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class UInt16Tests: XCTestCase {
    func testBytes() {
        let value: UInt16 = .random()
        let bytes = value.bytes

        let converted = Data(bytes).withUnsafeBytes { $0.load(as: UInt16.self) }

        XCTAssertEqual(converted, value)
    }
}
