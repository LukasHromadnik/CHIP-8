//
//  FX15.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//
import XCTest
@testable import Chip8

final class OpCodeFX15Tests: Chip8TestCase {
    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let registerValue: UInt8 = .random()
        chip8.v[x] = registerValue

        chip8.opcode = 0xF015 | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.delayTimer, Int(registerValue))
        XCTAssertEqual(chip8.pc, 2)
    }
}
