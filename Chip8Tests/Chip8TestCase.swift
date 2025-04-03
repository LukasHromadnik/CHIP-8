//
//  OpCodeTestCase.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

class Chip8TestCase: XCTestCase {
    var chip8: Chip8!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        chip8 = .init(rom: "")
        chip8.pc = 0
    }

    override func tearDown() {
        chip8 = nil

        super.tearDown()
    }

    override func invokeTest() {
        for _ in 0...100 {
            super.invokeTest()
        }
    }

    // MARK: - Public API

    func generateTwoDifferentRandom<R, T>(in range: R, ofType: T.Type = T.self) -> (T, T) where R: RangeExpression, R.Bound == T, T: Randomizable {
        let firstIndex: T = .random(in: range)
        while true {
            let secondIndex: T = .random(in: range)
            if secondIndex != firstIndex {
                return (firstIndex, secondIndex)
            }
        }

        assertionFailure("Unable to create two different indexes")
        return (.zero, .zero)
    }

    func generateRandomRegisters() -> (Int, Int) {
        generateTwoDifferentRandom(in: 0..<15)
    }
}
