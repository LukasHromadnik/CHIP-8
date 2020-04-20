//
//  FX29.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeFX29Tests: Chip8TestCase {
    func testRandom() {
        let letter: UInt8 = .random(in: 0..<16)
        let (x, _) = generateRandomRegisters()
        chip8.v[x] = letter

        chip8.opcode = 0xF029 | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.vI, UInt16(kFontSetCounter + Int(letter) * kFontLetterWidth))
        XCTAssertEqual(chip8.pc, 2)
    }
}
