//
//  8XY6.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode8XY6Tests: Chip8TestCase {
    func testZero() {
        let (x, _) = generateRandomRegisters()

        chip8.v[x] = 0b10101010

        chip8.opcode = 0x8000 | UInt16(x) << 8 | 6
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8006)
        XCTAssertEqual(chip8.v[x], 0b01010101)
        XCTAssertEqual(chip8.vf, 0)
        XCTAssertEqual(chip8.pc, 2)
    }

    func testOne() {
        let (x, _) = generateRandomRegisters()

        chip8.v[x] = 0b01010101

        chip8.opcode = 0x8000 | UInt16(x) << 8 | 6
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8006)
        XCTAssertEqual(chip8.v[x], 0b00101010)
        XCTAssertEqual(chip8.vf, 1)
        XCTAssertEqual(chip8.pc, 2)
    }

    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let value: UInt8 = .random()

        chip8.v[x] = value

        chip8.opcode = 0x8000 | UInt16(x) << 8 | 6
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8006)
        XCTAssertEqual(chip8.v[x], value >> 1)
        XCTAssertEqual(chip8.vf, value & 0x1)
        XCTAssertEqual(chip8.pc, 2)
    }
}
