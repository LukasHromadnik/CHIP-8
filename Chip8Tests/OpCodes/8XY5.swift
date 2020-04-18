//
//  8XY5.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode8XY5Tests: OpCodeTestCase {
    func testNoOveflow() {
        let (x, y) = generateRandomRegisters()
        let valueX: UInt8 = 5
        let valueY: UInt8 = 2

        chip8.v[x] = valueX
        chip8.v[y] = valueY

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 5
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8005)
        XCTAssertEqual(chip8.v[x], 3)
        XCTAssertEqual(chip8.v[y], valueY)
        XCTAssertEqual(chip8.vf, 0)
        XCTAssertEqual(chip8.pc, 2)
    }

    func testOveflow() {
        let (x, y) = generateRandomRegisters()
        let valueX: UInt8 = 1
        let valueY: UInt8 = 2

        chip8.v[x] = valueX
        chip8.v[y] = valueY

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 5
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8005)
        XCTAssertEqual(chip8.v[x], 255)
        XCTAssertEqual(chip8.v[y], valueY)
        XCTAssertEqual(chip8.vf, 1)
        XCTAssertEqual(chip8.pc, 2)
    }

    func testRandom() {
        let (x, y) = generateRandomRegisters()
        let valueX: UInt8 = .random()
        let valueY: UInt8 = .random()

        let overflow = valueY > valueX
        let diff = max(valueX, valueY) - min(valueX, valueY)
        let result = overflow ? 255 - diff + 1 : diff

        chip8.v[x] = valueX
        chip8.v[y] = valueY

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 5
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8005)
        XCTAssertEqual(chip8.v[x], result)
        XCTAssertEqual(chip8.v[y], valueY)
        XCTAssertEqual(chip8.vf, overflow ? 1 : 0)
        XCTAssertEqual(chip8.pc, 2)
    }
}
