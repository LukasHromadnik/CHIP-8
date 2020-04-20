//
//  00EE.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCode00EETests: Chip8TestCase {
    func testCode() {
        let randomPC: Int = .random(in: 0..<chip8.memory.count)
        let randomSP: Int = .random(in: 0..<chip8.stack.count)
        chip8.sp = randomSP
        chip8.stack[chip8.sp] = UInt16(randomPC)
        chip8.sp += 1

        chip8.opcode = 0x00EE
        XCTAssertNoThrow(try chip8.decodeOpcode())

        XCTAssertEqual(chip8.sp, randomSP)
        XCTAssertEqual(chip8.pc, randomPC + 2)
    }
}
