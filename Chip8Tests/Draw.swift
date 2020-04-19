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
        let height = 3

        chip8.vI = 2
        for i in 0..<height {
            for j in 0..<kSpriteLength {
                let memoryIndex = Int(chip8.vI) + i * kSpriteLength + j
                chip8.memory[memoryIndex] = (i + j) % 3 == 0 ? 1 : 0
            }
        }

        chip8.draw(x: x, y: y, height: height)

        for row in 0..<height {
            for col in 0..<kSpriteLength {
                let index = (row + Int(y)) * kDisplayWidth + col + Int(x)
                XCTAssertEqual(chip8.display[index], (row + col) % 3 == 0 ? 1 : 0)
            }
        }

        XCTAssertEqual(chip8.vf, 0)
    }

    func testFlip() {
        let x: UInt8 = 2
        let y: UInt8 = 2
        let height = 1

        chip8.vI = 8
        for i in 0..<kSpriteLength {
            chip8.memory[Int(chip8.vI) + i] = 1
        }

        chip8.draw(x: x, y: y, height: height)

        XCTAssertEqual(chip8.vf, 0)

        for i in 0..<kSpriteLength {
            chip8.memory[Int(chip8.vI) + i] = 0
        }

        chip8.draw(x: x, y: y, height: height)

        XCTAssertEqual(chip8.vf, 1)
    }
}
