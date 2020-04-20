//
//  9XY0.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode9XY0Tests: Chip8TestCase {
    func testSkip() {
        let (x, y) = generateRandomRegisters()
        chip8.v[x] = 1
        chip8.v[y] = 2

        chip8.opcode = 0x9000 | UInt16(x) << 8 | UInt16(y) << 4
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.pc, 4)
    }

    func testNoSkip() {
        let (x, y) = generateRandomRegisters()
        chip8.v[x] = 2
        chip8.v[y] = 2

        chip8.opcode = 0x9000 | UInt16(x) << 8 | UInt16(y) << 4
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.pc, 2)

    }

    func testRandom() {
        let (x, y) = generateRandomRegisters()
        let valueX: UInt8 = .random()
        let valueY: UInt8 = .random()

        chip8.v[x] = valueX
        chip8.v[y] = valueY

        chip8.opcode = 0x9000 | UInt16(x) << 8 | UInt16(y) << 4 | 0
        XCTAssertNoThrow(try chip8.decodeOpcode())

        let shouldSkip = valueX != valueY
        XCTAssertEqual(chip8.pc, shouldSkip ? 4 : 2)
    }
}
