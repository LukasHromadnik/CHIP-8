//
//  FX33.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeFX33Tests: Chip8TestCase {
    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let value: UInt8 = .random()
        chip8.v[x] = value
        let address: Int = .random(in: 0..<chip8.memory.count - 3)
        chip8.vI = UInt16(address)

        chip8.opcode = 0xF033 | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        let hunderds = Int(value) / 100
        let tens = (Int(value) / 10) % 10
        let ones = Int(value) % 10

        XCTAssertEqual(chip8.memory[address], UInt8(hunderds))
        XCTAssertEqual(chip8.memory[address + 1], UInt8(tens))
        XCTAssertEqual(chip8.memory[address + 2], UInt8(ones))
        XCTAssertEqual(chip8.pc, 2)
    }
}

