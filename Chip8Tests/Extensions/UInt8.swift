//
//  UInt8.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import Foundation

extension UInt8 {
    static func random() -> UInt8 {
        random(in: 0..<max)
    }
}
