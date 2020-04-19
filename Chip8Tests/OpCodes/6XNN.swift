//
//  6XNN.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode6XNNTests: Chip8TestCase {
    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let value: UInt8 = .random()

        chip8.opcode = 0x6000 | UInt16(x) << 8 | UInt16(value)
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.v[x], value)
        XCTAssertEqual(chip8.pc, 2)
    }
}
