//
//  FX55.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeFX55Tests: Chip8TestCase {
    func testRandom() {
        var data = [UInt8](repeating: 0, count: 16)
        for i in 0..<data.count {
            data[i] = .random()
            chip8.v[i] = data[i]
        }
        let address: Int = .random(in: 0..<chip8.memory.count - data.count)
        chip8.vI = UInt16(address)

        let (x, _) = generateRandomRegisters()

        chip8.opcode = 0xF055 | UInt16(x) << 8
        XCTAssertNoThrow(try chip8.decodeOpcode())

        for i in 0...x {
            XCTAssertEqual(chip8.memory[address + i], data[i])
        }
    }
}
