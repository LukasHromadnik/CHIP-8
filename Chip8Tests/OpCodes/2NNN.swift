//
//  2NNN.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode2NNNTests: OpCodeTestCase {
    func testRandom() {
        let randomAddressBefore: UInt16 = .random(in: 0...0xFFF)
        let randomAddressAfter: UInt16 = .random(in: 0...0xFFF)
        let randomSP: Int = .random(in: 0..<chip8.stack.count)

        chip8.pc = Int(randomAddressBefore)
        chip8.sp = randomSP

        chip8.opcode = 0x2000 | randomAddressAfter
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.sp, randomSP + 1)
        XCTAssertEqual(chip8.stack[chip8.sp - 1], randomAddressBefore)
        XCTAssertEqual(chip8.pc, Int(randomAddressAfter))
    }
}
