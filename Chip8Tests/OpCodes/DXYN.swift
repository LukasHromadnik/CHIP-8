//
//  DXYN.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

final class OpCodeDXYNTests: Chip8TestCase {
    func testRandom() {
        chip8.clearDisplay()
        chip8.vI = 0

        let (x, y) = generateRandomRegisters()
        let coordX: Int = .random(in: 0..<kDisplayWidth)
        let coordY: Int = .random(in: 0..<kDisplayHeight)
        chip8.v[x] = UInt8(coordX)
        chip8.v[y] = UInt8(coordY)
        let height: Int = .random(in: 0...0xF)
        var sprite = [UInt8](repeating: 0, count: height)
        for i in 0..<height { sprite[i] = .random() }
        for i in 0..<sprite.count {
            chip8.memory[Int(chip8.vI) + i] = sprite[i]
        }

        chip8.opcode = 0xD000 | UInt16(x) << 8 | UInt16(y) << 4 | UInt16(height)
        XCTAssertNoThrow(try chip8.decodeOpcode())

        for j in 0..<kDisplayHeight {
            for i in 0..<kDisplayWidth {
                let index = j * kDisplayWidth + i
                if (coordX..<coordX + kSpriteLength).contains(i) && (coordY..<coordY + height).contains(j) {
                    let row = sprite[j - coordY]
                    let pixelValue = row >> (kSpriteLength - 1 - (i - coordX))
                    let pixel: UInt8 = pixelValue & 1
                    XCTAssertEqual(chip8.display[index], pixel)
                } else {
                    if chip8.display[index] != 0 {
                        print(coordX, coordY, i, j, index)
                    }
                    XCTAssertEqual(chip8.display[index], 0)
                }

            }
        }
    }
}
