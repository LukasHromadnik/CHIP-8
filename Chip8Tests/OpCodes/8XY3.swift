//
//  8XY3.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode8XY3Tests: Chip8TestCase {
    func testRandom() {
        let (x, y) = generateRandomRegisters()
        let valueX: UInt8 = .random()
        let valueY: UInt8 = .random()

        chip8.v[x] = valueX
        chip8.v[y] = valueY

        var result: UInt8 = 0
        for i in 0..<8 {
            let bitX = (valueX & (0x80 >> i)) >> (Int(7) - i)
            let bitY = (valueY & (0x80 >> i)) >> (Int(7) - i)
            result |= ((bitX ^ bitY) << (Int(7) - i))
        }

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 3
        chip8.decodeOpcode()

        XCTAssertEqual(chip8.opcode & 0xF00F, 0x8003)
        XCTAssertEqual(chip8.v[x], result)
        XCTAssertEqual(chip8.v[y], valueY)
        XCTAssertEqual(chip8.pc, 2)
    }
}
