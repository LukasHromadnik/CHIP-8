//
//  UInt16.swift
//  Chip8Tests
//
//  Created by Lukáš Hromadník on 19/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import Foundation

extension UInt16 {
    var bytes: [UInt8] {
        let upper = UInt8(self >> 8)
        let lower = UInt8((self << 8) >> 8)
        return [lower, upper]
    }
}
