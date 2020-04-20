//
//  Chip8Tests.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

@testable import Chip8
import XCTest

final class Chip8Test: Chip8TestCase {
    func testFontSet() {
        let fontSetCounter = kFontSetCounter
        let fontSet = Chip8.fontSet

        for i in 0..<fontSet.count {
            XCTAssertEqual(chip8.memory[fontSetCounter + i], fontSet[i])
        }
    }
}
