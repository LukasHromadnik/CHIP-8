//
//  3XNN.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode3NNNTests: Chip8TestCase {
    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let value: UInt8 = .random()
        let addressValue: UInt8 = .random()

        chip8.v[x] = value
        chip8.opcode = 0x3000 | UInt16(x) << 8 | UInt16(addressValue)
        XCTAssertNoThrow(try chip8.decodeOpcode())

        let shouldSkip = value == addressValue
        XCTAssertEqual(chip8.pc, shouldSkip ? 4 : 2)
    }

    func testSkip() {
        let (x, _) = generateRandomRegisters()
        let value: UInt8 = .random()

        chip8.v[x] = value
        chip8.opcode = 0x3000 | UInt16(x) << 8 | UInt16(value)
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.pc, 4)
    }

    func testNoSkip() {
        let (x, _) = generateRandomRegisters()
        let (valueX, valueY) = generateTwoDifferentRandom(in: 0...0xFF, ofType: UInt8.self)

        chip8.v[x] = valueX
        chip8.opcode = 0x3000 | UInt16(x) << 8 | UInt16(valueY)
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.pc, 2)
    }
}
