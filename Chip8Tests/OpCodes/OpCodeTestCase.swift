//
//  OpCodeTestCase.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import XCTest
@testable import Chip8

class OpCodeTestCase: XCTestCase {
    var chip8: Chip8!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        chip8 = .init()
        chip8.pc = 0
    }

    override func tearDown() {
        chip8 = nil

        super.tearDown()
    }

    // MARK: - Public API

    func generateRandomRegisters() -> (Int, Int) {
        let firstIndex: Int = .random(in: 0..<15)
        while true {
            let secondIndex: Int = .random(in: 0..<15)
            if secondIndex != firstIndex {
                return (firstIndex, secondIndex)
            }
        }

        assertionFailure("Unable to create two different indexes")
        return (0, 0)
    }
}
