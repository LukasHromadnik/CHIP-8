//
//  8XY4.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode8XY4Tests: Chip8TestCase {
    func testNoOveflow() {
        let (x, y) = generateRandomRegisters()
        let valueX: UInt8 = 1
        let valueY: UInt8 = 2

        chip8.v[x] = valueX
        chip8.v[y] = valueY

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 4
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8004)
        XCTAssertEqual(chip8.v[x], 3)
        XCTAssertEqual(chip8.v[y], valueY)
        XCTAssertEqual(chip8.vf, 0)
        XCTAssertEqual(chip8.pc, 2)
    }

    func testOveflow() {
        let (x, y) = generateRandomRegisters()
        let valueX: UInt8 = 1
        let valueY: UInt8 = 255

        chip8.v[x] = valueX
        chip8.v[y] = valueY

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 4
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8004)
        XCTAssertEqual(chip8.v[x], 0)
        XCTAssertEqual(chip8.v[y], valueY)
        XCTAssertEqual(chip8.vf, 1)
        XCTAssertEqual(chip8.pc, 2)
    }

    func testRandom() {
        let (x, y) = generateRandomRegisters()
        let valueX: UInt8 = .random()
        let valueY: UInt8 = .random()

        let sum: UInt16 = UInt16(valueX) + UInt16(valueY)
        let overflow = sum > UInt8.max

        chip8.v[x] = valueX
        chip8.v[y] = valueY

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 4
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8004)
        XCTAssertEqual(chip8.v[x], UInt8((sum << 8) >> 8))
        XCTAssertEqual(chip8.v[y], valueY)
        XCTAssertEqual(chip8.vf, overflow ? 1 : 0)
        XCTAssertEqual(chip8.pc, 2)
    }
}
