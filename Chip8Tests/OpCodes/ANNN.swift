//
//  ANNN.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeANNNTests: Chip8TestCase {
    func testRandom() {
        let value: UInt16 = .random(in: 0...0xFFF)

        chip8.opcode = 0xA000 | value
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.vI, value)
        XCTAssertEqual(chip8.pc, 2)
    }
}
