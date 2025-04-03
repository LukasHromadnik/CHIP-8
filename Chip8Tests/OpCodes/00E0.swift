//
//  00E0.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode00E0Tests: Chip8TestCase {
    func testCode() {
        for i in 0..<chip8.display.count {
            chip8.display[i] = .random()
        }

        chip8.opcode = 0x00E0
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.display.reduce(0, +), 0)
        XCTAssertTrue(chip8.shouldDraw)
        XCTAssertEqual(chip8.pc, 2)
    }
}
