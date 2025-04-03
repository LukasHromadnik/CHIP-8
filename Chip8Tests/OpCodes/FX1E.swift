//
//  FX1E.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeFX1ETests: Chip8TestCase {
    func testNoOverflow() {
        let (x, _) = generateRandomRegisters()
        chip8.v[x] = 1
        chip8.vI = 1

        chip8.opcode = 0xF01E | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.vI, 2)
        XCTAssertEqual(chip8.vf, 0)
        XCTAssertEqual(chip8.pc, 2)
    }

    func testOverflow() {
        let (x, _) = generateRandomRegisters()
        chip8.v[x] = 1
        chip8.vI = .max

        chip8.opcode = 0xF01E | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.vI, 0)
        XCTAssertEqual(chip8.vf, 1)
        XCTAssertEqual(chip8.pc, 2)
    }

    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let vxValue: UInt8 = .random()
        let vIValue: UInt16 = .random()
        chip8.v[x] = vxValue
        chip8.vI = vIValue

        chip8.opcode = 0xF01E | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        let hasOverflow = UInt16.max - UInt16(vxValue) < vIValue
        let result = vIValue &+ UInt16(vxValue)

        XCTAssertEqual(chip8.vI, result)
        XCTAssertEqual(chip8.vf, hasOverflow ? 1 : 0)
        XCTAssertEqual(chip8.pc, 2)
    }
}

