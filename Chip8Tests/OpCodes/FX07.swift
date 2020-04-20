//
//  FX07.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeFX07Tests: Chip8TestCase {
    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let delayTimerValue: UInt8 = .random()
        chip8.delayTimer = Int(delayTimerValue)

        chip8.opcode = 0xF007 | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.v[x], delayTimerValue)
        XCTAssertEqual(chip8.pc, 2)
    }
}
