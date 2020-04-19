//
//  RandomizerMock.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 19/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

@testable import Chip8

class RandomizerMock: RandomizerProtocol {
    var bytes: [UInt8] = []

    func random<R, T>(in range: R, ofType type: T.Type) -> T where R: RangeExpression, T: Randomizable, T == R.Bound {
        Data(bytes).withUnsafeBytes { $0.load(as: T.self) }
    }
}
