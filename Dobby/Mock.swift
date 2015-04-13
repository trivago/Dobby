//  Copyright (c) 2015 Rheinfabrik. All rights reserved.

import Foundation

public struct Mock<Interaction: Equatable> {
    public var interactions: [Interaction] = []

    public init() {}
}

// MARK: - Basics

public func record<Interaction: Equatable>(inout mock: Mock<Interaction>, interaction: Interaction) {
    mock.interactions.append(interaction)
}

// MARK: - Verification

public func verify<Interaction: Equatable, C: CollectionType where C.Generator.Element == Interaction>(mock: Mock<Interaction>, interactions: C) -> Bool {
    var index = interactions.startIndex
    for interaction in mock.interactions {
        if interaction == interactions[index] {
            index = advance(index, 1)
            if index == interactions.endIndex {
                return true
            }
        }
    }

    return false
}
