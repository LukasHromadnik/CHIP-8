//
//  CXNN.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeCXNNTests: Chip8TestCase {
    var randomizer: RandomizerMock!

    override func setUp() {
        super.setUp()

        randomizer = .init()
        chip8.randomizer = randomizer
    }

    override func tearDown() {
        randomizer = nil

        super.tearDown()
    }

    func testRandom() {
        let (x, _) = generateRandomRegisters()
        let nn: UInt8 = .random()
        let randomValue: UInt8 = .random()
        randomizer.bytes = [randomValue]

        chip8.opcode = 0xC000 | UInt16(x) << 8 | UInt16(nn)
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.v[x], nn & randomValue)
        XCTAssertEqual(chip8.pc, 2)
    }
}
