//
//  7XNN.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode7XNNTests: OpCodeTestCase {
    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let initialValue: UInt8 = .random()
        let value: UInt8 = .random()

        chip8.v[x] = initialValue

        chip8.opcode = 0x7000 | UInt16(x) << 8 | UInt16(value)
        chip8.decodeOpcode()

        let result = UInt8(((UInt16(initialValue) + UInt16(value)) << 8) >> 8)
        XCTAssertEqual(chip8.v[x], result)
        XCTAssertEqual(chip8.pc, 2)
    }
}
