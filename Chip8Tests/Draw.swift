//
//  Draw.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 19/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

class Draw: Chip8TestCase {
    func testDraw() {
        let x: UInt8 = 2
        let y: UInt8 = 3
        let height = 4

        chip8.clearDisplay()

        chip8.vI = 2

        chip8.memory[Int(chip8.vI)]     = 0xF0
        chip8.memory[Int(chip8.vI) + 1] = 0x90
        chip8.memory[Int(chip8.vI) + 2] = 0x90
        chip8.memory[Int(chip8.vI) + 3] = 0xF0

        chip8.draw(x: x, y: y, height: height)
        chip8.draw(x: x + 2, y: y + 2, height: height)

        let sprite: [[UInt8]] = [
            [1, 1, 1, 1, 0, 0, 0, 0],
            [1, 0, 0, 1, 0, 0, 0, 0],
            [1, 0, 1, 0, 1, 1, 0, 0],
            [1, 1, 0, 1, 0, 1, 0, 0],
            [0, 0, 1, 0, 0, 1, 0, 0],
            [0, 0, 1, 1, 1, 1, 0, 0]
        ]

        for i in 0..<6 {
            for j in 0..<kSpriteLength {
                let index = (Int(y) + i) * kDisplayWidth + j + Int(x)
                let pixel = chip8.display[index]
                XCTAssertEqual(pixel, sprite[i][j])
            }
        }

        XCTAssertEqual(chip8.vf, 1)
    }

    func testNoSkip() {
        let x: UInt8 = 2
        let y: UInt8 = 3
        let height = 4

        chip8.clearDisplay()

        chip8.vI = 2

        chip8.memory[Int(chip8.vI)]     = 0xF0
        chip8.memory[Int(chip8.vI) + 1] = 0x90
        chip8.memory[Int(chip8.vI) + 2] = 0x90
        chip8.memory[Int(chip8.vI) + 3] = 0xF0

        chip8.draw(x: x, y: y, height: height)
        chip8.draw(x: x + 5, y: y + 5, height: height)

        XCTAssertEqual(chip8.vf, 0)
    }
}
