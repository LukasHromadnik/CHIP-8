//
//  UndefinedOpcodesTests.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 20/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

@testable import Chip8
import XCTest

func XCTAssertThrows<T, E>(_ block: @autoclosure () throws -> T, _ exceptionType: E) where E: Error, E: Equatable {
    XCTAssertThrowsError(try block()) { error in
        XCTAssertEqual(error as? E, exceptionType)
    }
}

final class UndefinedOpcodesTests: Chip8TestCase {

    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()

        chip8.shouldCheckRecursion = false
    }

    // MARK: - Tests

    func test0NNN() {
        func createOpcode() -> UInt16 { .random(in: 0...0xFFF) }
        var opcode: UInt16 = createOpcode()
        let definedOpcodes: [UInt16] = [0x00E0, 0x00EE]

        var counter = 0
        while counter < 100 {
            while definedOpcodes.contains(opcode) {
                opcode = createOpcode()
            }

            chip8.opcode = opcode
            XCTAssertThrows(try chip8.decodeOpcode(), Chip8Error.notImplemented(opcode))

            counter += 1

            opcode = createOpcode()
        }
    }

    func test8XY8() {
        let (x, y) = generateRandomRegisters()

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 8

        XCTAssertThrows(try chip8.decodeOpcode(), Chip8Error.undefinedOpcode(chip8.opcode))
    }

    func test8XY9() {
        let (x, y) = generateRandomRegisters()

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 9

        XCTAssertThrows(try chip8.decodeOpcode(), Chip8Error.undefinedOpcode(chip8.opcode))
    }

    func test8XYA() {
        let (x, y) = generateRandomRegisters()

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 0xA

        XCTAssertThrows(try chip8.decodeOpcode(), Chip8Error.undefinedOpcode(chip8.opcode))
    }

    func test8XYB() {
        let (x, y) = generateRandomRegisters()

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 0xB

        XCTAssertThrows(try chip8.decodeOpcode(), Chip8Error.undefinedOpcode(chip8.opcode))
    }

    func test8XYC() {
        let (x, y) = generateRandomRegisters()

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 0xC

        XCTAssertThrows(try chip8.decodeOpcode(), Chip8Error.undefinedOpcode(chip8.opcode))
    }

    func test8XYD() {
        let (x, y) = generateRandomRegisters()

        chip8.opcode = 0x8000 | UInt16(x) << 8 | UInt16(y) << 4 | 0xD

        XCTAssertThrows(try chip8.decodeOpcode(), Chip8Error.undefinedOpcode(chip8.opcode))
    }

    func testENNN() {
        func createOpcode() -> UInt16 { 0xE000 | .random(in: 0...0xFFF) }
        var opcode: UInt16 = createOpcode()
        let definedOpcodes: [UInt16] = [0xE09E, 0xE0A1]

        var counter = 0
        while counter < 100 {
            while definedOpcodes.contains(opcode & 0xF0FF) {
                opcode = createOpcode()
            }

            chip8.opcode = opcode
            XCTAssertThrows(try chip8.decodeOpcode(), Chip8Error.undefinedOpcode(opcode))

            counter += 1

            opcode = createOpcode()
        }
    }

    func testFNNN() {
        func createOpcode() -> UInt16 { 0xF000 | .random(in: 0...0xFFF) }
        var opcode: UInt16 = createOpcode()
        let definedOpcodes: [UInt16] = [0xF007, 0xF00A, 0xF015, 0xF018, 0xF01E, 0xF029, 0xF033, 0xF055, 0xF065]

        var counter = 0
        while counter < 100 {
            while definedOpcodes.contains(opcode & 0xF0FF) {
                opcode = createOpcode()
            }
            
            chip8.opcode = opcode
            XCTAssertThrows(try chip8.decodeOpcode(), Chip8Error.undefinedOpcode(opcode))
            
            counter += 1
            
            opcode = createOpcode()
        }
    }
}
