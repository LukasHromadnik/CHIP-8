//
//  Randomizable.swift
//  CHIP-8
//
//  Created by Lukáš Hromadník on 18/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import Foundation

protocol Randomizable: Comparable {
    static var zero: Self { get }
    static var max: Self { get }
    static func random(in range: Range<Self>) -> Self
    static func random(in range: ClosedRange<Self>) -> Self
}

extension Randomizable {
    static func random<R>(in range: R) -> Self where R: RangeExpression, R.Bound == Self {
        if let range = range as? Range<Self> {
            return random(in: range)
        } else if let range = range as? ClosedRange<Self> {
            return random(in: range)
        }

        assertionFailure("Undefined Range")
        return .zero
    }

    static func random() -> Self {
        random(in: zero...max)
    }
}

extension Int: Randomizable { }
extension UInt8: Randomizable { }
extension UInt16: Randomizable { }
