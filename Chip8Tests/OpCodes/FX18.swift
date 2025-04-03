//
//  FX18.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeFX18Tests: Chip8TestCase {
    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let registerValue: UInt8 = .random()
        chip8.v[x] = registerValue

        chip8.opcode = 0xF018 | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.soundTimer, Int(registerValue))
        XCTAssertEqual(chip8.pc, 2)
    }
}
