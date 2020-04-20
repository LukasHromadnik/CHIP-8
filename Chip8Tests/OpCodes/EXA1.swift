//
//  EXA1.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeEXA1Tests: Chip8TestCase {
    func testEX9ESkip() {
        chip8.v[0] = 1
        chip8.keyboard = 0x0000

        chip8.opcode = 0xE0A1
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.pc, 4)
    }

    func testEX9ENoSkip() {
        chip8.v[0] = 1
        chip8.keyboard = 0x0002

        chip8.opcode = 0xE0A1
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.pc, 2)
    }

    func testEX9ERandom() {
        let (x, _) = generateRandomRegisters()
        let registerKey: UInt8 = .random(in: 0..<16)
        let pressedKey: UInt8 = .random(in: 0..<16)

        chip8.keyboard = 0
        chip8.pc = 0
        chip8.v[x] = registerKey
        chip8.press(Int(pressedKey))

        chip8.opcode = 0xE0A1 | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        let shouldSkip = registerKey != pressedKey
        XCTAssertEqual(chip8.pc, shouldSkip ? 4 : 2)
    }
}
