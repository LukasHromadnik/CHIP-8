//
//  1NNN.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode1NNNTests: Chip8TestCase {
    func testRandom() {
        let randomAddress: UInt16 = .random(in: 0..<0xFFF)

        chip8.opcode = 0x1000 | randomAddress
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.pc, Int(randomAddress))
    }
}
