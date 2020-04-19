//
//  Chip8.swift
//  CHIP-8
//
//  Created by Lukáš Hromadník on 16/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import Foundation

protocol RandomizerProtocol {
    func random<R, T>(in range: R, ofType type: T.Type) -> T where R: RangeExpression, R.Bound == T, T: Randomizable
}

extension RandomizerProtocol {
    func random<R, T>(in range: R) -> T where R: RangeExpression, R.Bound == T, T: Randomizable
    {
        random(in: range, ofType: T.self)
    }
}

public class Randomizer: RandomizerProtocol {
   func random<R, T>(in range: R, ofType type: T.Type) -> T where R: RangeExpression, R.Bound == T, T: Randomizable {
        T.random(in: range)
    }
}

let kSpriteLength = 8
let kInitProgramCounter: Data.Index = 0x200
let kFontSetCounter: Data.Index = 0x50
let kDisplayWidth = 64
let kDisplayHeight = 32

public class Chip8 {
    /// Memory, size 4 096 bytes
    var memory = Data(repeating: 0, count: 4096)

    /// Program counter
    var pc: Data.Index = kInitProgramCounter

    /// Registers
    var v = [UInt8](repeating: 0, count: 16)

    /// Carry register
    var vf: UInt8 {
        get { v[15] }
        set { v[15] = newValue }
    }

    /// Address register
    var vI: UInt16 = 0

    /// Stack of size 48
    var stack = [UInt16](repeating: 0, count: 48)
    var sp: Int = 0

    var delayTimer = 0
    var soundTimer = 0

    var display = [UInt8](repeating: 0, count: kDisplayWidth * kDisplayHeight)
    public var onDisplayUpdate: (([UInt8]) -> Void)?

    var opcode: UInt16 = 0

    // Number of keys
    var keys = [UInt8](repeating: 0, count: 16)

    var shouldDraw = false

    private var lastOpcode: UInt16?

    var randomizer: RandomizerProtocol = Randomizer()
    private let rom: String

    public init(rom: String) {
        self.rom = rom
    }

    public func run() {
        setup()
        loadROM(rom)

        DispatchQueue(label: "emulator").async {
            while true {
                self.makeStep()

                if self.shouldDraw {
                    self.updateCanvas()
                }

                self.loadKeys()

                usleep(10000)
            }
        }
    }

    private func setup() {
        for i in 0..<Chip8.fontSet.count {
            memory[0x50 + i * 8] = Chip8.fontSet[i]
        }
    }

    private func loadROM(_ name: String) {
        guard let resourceURL = Bundle.main.url(forResource: name, withExtension: nil) else { assertionFailure("Unable to load resource: \(name)"); return }
        let rom = try! Data(contentsOf: resourceURL)

        for i in 0..<rom.count {
            memory[kInitProgramCounter + i] = rom[i]
        }
    }

    private func makeStep() {
        fetchOpcode()
        decodeOpcode()
        updateTimers()
    }

    private func fetchOpcode() {
        opcode = UInt16(memory[pc]) << 8 | UInt16(memory[pc + 1])
    }

    func decodeOpcode() {
//        if lastOpcode == opcode {
//            assertionFailure("Possible recursion")
//            return
//        }
        lastOpcode = opcode
        switch opcode & 0xF000 {
        case 0x0000:
            switch opcode & 0x0FFF {
            case 0x00E0:
                // 00E0
                // Clears the screen.
                clearDisplay()
                shouldDraw = true
                pc += 2

            case 0x00EE:
                // 00EE
                // Returns from a subroutine.
                sp -= 1
                pc = Data.Index(stack[sp])

            default:
                // 0NNN
                // Calls RCA 1802 program at address NNN. Not necessary for most ROMs
                assertionFailure("Not implemented")
            }

        case 0x1000:
            // 1NNN
            // Jumps to address NNN.
            pc = Data.Index(opcode & 0x0FFF)

        case 0x2000:
            // 2NNN
            // Calls subroutine at NNN.
            stack[sp] = UInt16(pc)
            sp += 1
            pc = Data.Index(opcode & 0x0FFF)

        case 0x3000:
            // 3XNN
            // Skips the next instruction if VX equals NN. (Usually the next instruction is a jump to skip a code block)
            let x = Int(opcode & 0x0F00) >> 8
            if v[x] == opcode & 0x00FF {
                pc += 2
            }
            pc += 2

        case 0x4000:
            // 4XNN
            // Skips the next instruction if VX doesn't equal NN. (Usually the next instruction is a jump to skip a code block)
            let x = Int(opcode & 0x0F00) >> 8
            if v[x] != opcode & 0x00FF {
                pc += 2
            }
            pc += 2

        case 0x5000:
            // 5XY0
            // Skips the next instruction if VX equals VY. (Usually the next instruction is a jump to skip a code block)
            let x = Int(opcode & 0x0F00) >> 8
            let y = Int(opcode & 0x00F0) >> 4
            if v[x] == v[y] {
                pc += 2
            }
            pc += 2

        case 0x6000:
            // 6XNN
            // Sets VX to NN.
            let x = Int(opcode & 0x0F00) >> 8
            v[x] = UInt8(opcode & 0x00FF)
            pc += 2

        case 0x7000:
            // 7XNN
            // Adds NN to VX. (Carry flag is not changed)
            let x = Int(opcode & 0x0F00) >> 8
            v[x] &+= UInt8(opcode & 0x00FF)
            pc += 2

        case 0x8000:
            let x = Int(opcode & 0x0F00) >> 8
            let y = Int(opcode & 0x00F0) >> 4

            switch opcode & 0xF00F {
            case 0x8000:
                // 8XY0
                // Sets VX to the value of VY.
                v[x] = v[y]

            case 0x8001:
                // 8XY1
                // Sets VX to VX or VY. (Bitwise OR operation)
                v[x] |= v[y]

            case 0x8002:
                // 8XY2
                // Sets VX to VX and VY. (Bitwise AND operation)
                v[x] &= v[y]

            case 0x8003:
                // 8XY3
                // Sets VX to VX xor VY.
                v[x] ^= v[y]

            case 0x8004:
                // 8XY4
                // Adds VY to VX. VF is set to 1 when there's a carry, and to 0 when there isn't.
                let (partial, overflow) = v[x].addingReportingOverflow(v[y])
                vf = overflow ? 1 : 0
                v[x] = partial

            case 0x8005:
                // 8XY5
                // VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
                let (partial, overflow) = v[x].subtractingReportingOverflow(v[y])
                vf = overflow ? 1 : 0
                v[x] = partial

            case 0x8006:
                // 8XY6
                // Stores the least significant bit of VX in VF and then shifts VX to the right by 1.
                vf = v[x] & 0x1
                v[x] >>= 1

            case 0x8007:
                // 8XY7
                // Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
                let (partial, overflow) = v[y].subtractingReportingOverflow(v[x])
                v[x] = partial
                vf = overflow ? 1 : 0

            case 0x800E:
                // 8XYE
                // Stores the most significant bit of VX in VF and then shifts VX to the left by 1.
                vf = v[x] & 0x80
                v[x] <<= 1

            default:
                assertionFailure(String(format: "Undefined opcode 0x%X", opcode))
            }

            pc += 2

        case 0x9000:
            // 9XY0
            // Skips the next instruction if VX doesn't equal VY. (Usually the next instruction is a jump to skip a code block
            let x = Int(opcode & 0x0F00) >> 8
            let y = Int(opcode & 0x00F0) >> 4
            if v[x] != v[y] {
                pc += 2
            }
            pc += 2

        case 0xA000:
            // ANNN
            // Sets I to the address NNN.
            vI = opcode & 0x0FFF
            pc += 2

        case 0xB000:
            // BNNN
            // Jumps to the address NNN plus V0.
            pc = Data.Index(opcode & 0x0FFF) + Int(v[0])

        case 0xC000:
            // CXNN
            // Sets VX to the result of a bitwise and operation on a random number (Typically: 0 to 255) and NN.
            let x = Int(opcode & 0x0F00) >> 8
            let rand: UInt8 = randomizer.random(in: 0...255)
            let mask = UInt8(opcode & 0x00FF)
            v[x] = rand & mask
            pc += 2

        case 0xD000:
            // DXYN
            // Draws a sprite at coordinate (VX, VY) that has a width of 8 pixels and a height of N pixels.
            // Each row of 8 pixels is read as bit-coded starting from memory location I;
            // I value doesn’t change after the execution of this instruction.
            // As described above, VF is set to 1 if any screen pixels are flipped from set to unset when the sprite is drawn,
            // and to 0 if that doesn’t happen
            let x = Int(opcode & 0x0F00) >> 8
            let y = Int(opcode & 0x00F0) >> 4
            let height = Int(opcode & 0x000F)

            draw(x: v[x], y: v[y], height: height)

            shouldDraw = true
            pc += 2

        case 0xE000:
            switch opcode & 0xFFFF {
            case 0xE09E:
                // EX9E
                // Skips the next instruction if the key stored in VX is pressed. (Usually the next instruction is a jump to skip a code block)
                let x = Int(opcode & 0x0F00) >> 8
                let keyIndex = Int(v[x])
                if keys[keyIndex] == 1 {
                    pc += 2
                }

            case 0xE0A1:
                // EXA1
                // Skips the next instruction if the key stored in VX isn't pressed. (Usually the next instruction is a jump to skip a code block)
                let x = Int(opcode & 0x0F00) >> 8
                let keyIndex = Int(v[x])
                if keys[keyIndex] == 0 {
                    pc += 2
                }

            default:
                assertionFailure(String(format: "Undefined opcode 0x%X", opcode))
            }

            pc += 2

        case 0xF000:
            switch opcode & 0xF0FF {
            case 0xF007:
                // FX07
                // Sets VX to the value of the delay timer.
                let x = Int(opcode & 0x0F00) >> 8
                v[x] = UInt8(delayTimer)

            case 0xF00A:
                // FX0A
                // A key press is awaited, and then stored in VX. (Blocking Operation. All instruction halted until next key event)
                assertionFailure("Not implemented")

            case 0xF015:
                // FX15
                // Sets the delay timer to VX.
                let x = Int(opcode & 0x0F00) >> 8
                delayTimer = Int(v[x])

            case 0xF018:
                // FX18
                // Sets the sound timer to VX.
                let x = Int(opcode & 0x0F00) >> 8
                soundTimer = Int(v[x])

            case 0xF01E:
                // FX1E
                // Adds VX to I. VF is set to 1 when there is a range overflow (I+VX>0xFFF), and to 0 when there isn't.[c]
                let x = Int(opcode & 0x0F00) >> 8
                let (partial, overflow) = vI.addingReportingOverflow(UInt16(v[x]))
                vI = partial
                vf = overflow ? 1 : 0

            case 0xF029:
                // FX29
                // Sets I to the location of the sprite for the character in VX. Characters 0-F (in hexadecimal) are represented by a 4x5 font.
                let x = Int(opcode & 0x0F00) >> 8
                let letter = Int(v[x])
                vI = UInt16(kFontSetCounter + letter * 5 * 8)

            case 0xF033:
                // FX33
                // Stores the binary-coded decimal representation of VX, with the most significant of three digits at the address in I,
                // the middle digit at I plus 1, and the least significant digit at I plus 2.
                // (In other words, take the decimal representation of VX, place the hundreds digit in memory at location in I,
                // the tens digit at location I+1, and the ones digit at location I+2.)
                let x = Int(opcode & 0x0F00) >> 8
                memory[Int(vI)]     = v[x] / 100
                memory[Int(vI) + 1] = (v[x] / 10) % 10
                memory[Int(vI) + 2] = (v[x] % 100) % 10

            case 0xF055:
                // FX55
                // Stores V0 to VX (including VX) in memory starting at address I. The offset from I is increased by 1 for each value written, but I itself is left unmodified.
                let x = Int(opcode & 0x0F00) >> 8
                for i in 0...x {
                    memory[Int(vI) + i] = v[i]
                }

            case 0xF065:
                // FX65
                // Fills V0 to VX (including VX) with values from memory starting at address I. The offset from I is increased by 1 for each value written, but I itself is left unmodified.
                let x = Int(opcode & 0x0F00) >> 8
                for i in 0...x {
                    v[i] = memory[Int(vI) + i]
                }

            default:
                assertionFailure(String(format: "Undefined opcode 0x%X", opcode))
            }

            pc += 2

        default:
            assertionFailure(String(format: "Undefined opcode 0x%X", opcode))
        }
    }

    func clearDisplay() {
        for i in 0..<display.count {
            display[i] = 0
        }
    }

    /// Each row of 8 pixels is read as bit-coded starting from memory location I;
    func draw(x: UInt8, y: UInt8, height: Int) {
        vf = 0
        let x = Int(x)
        let y = Int(y)
        for row in 0..<height {
            let pixels = memory[Int(vI) + row]
            for col in 0..<kSpriteLength {
                guard pixels & (0x80 >> col) != 0 else { continue }
                let displayIndex = (row + y) * kDisplayWidth + col + x
                if display[displayIndex] == 1 {
                    vf = 1
                }

                display[displayIndex] ^= 1
            }
        }
    }

    private func updateTimers() {
        if delayTimer > 0 {
            delayTimer -= 1
        }

        if soundTimer > 0 {
            soundTimer -= 1

            if soundTimer == 0 {
                print("BEEP!")
            }
        }
    }

    private func updateCanvas() {
        shouldDraw = false
        DispatchQueue.main.async { [unowned self] in
            self.onDisplayUpdate?(self.display)
        }
    }

    private func loadKeys() {
    }
}

extension Chip8 {
    static let fontSet: [UInt8] = [
        0xF0, 0x90, 0x90, 0x90, 0xF0, // 0
        0x20, 0x60, 0x20, 0x20, 0x70, // 1
        0xF0, 0x10, 0xF0, 0x80, 0xF0, // 2
        0xF0, 0x10, 0xF0, 0x10, 0xF0, // 3
        0x90, 0x90, 0xF0, 0x10, 0x10, // 4
        0xF0, 0x80, 0xF0, 0x10, 0xF0, // 5
        0xF0, 0x80, 0xF0, 0x90, 0xF0, // 6
        0xF0, 0x10, 0x20, 0x40, 0x40, // 7
        0xF0, 0x90, 0xF0, 0x90, 0xF0, // 8
        0xF0, 0x90, 0xF0, 0x10, 0xF0, // 9
        0xF0, 0x90, 0xF0, 0x90, 0x90, // A
        0xE0, 0x90, 0xE0, 0x90, 0xE0, // B
        0xF0, 0x80, 0x80, 0x80, 0xF0, // C
        0xE0, 0x90, 0x90, 0x90, 0xE0, // D
        0xF0, 0x80, 0xF0, 0x80, 0xF0, // E
        0xF0, 0x80, 0xF0, 0x80, 0x80  // F
    ]
}
