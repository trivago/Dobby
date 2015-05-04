public class Mock<Interaction: Equatable> {
    public var interactions: [Interaction] = []

    public init() {}
}

// MARK: - Basics

public func record<Interaction: Equatable>(mock: Mock<Interaction>, interaction: Interaction) {
    mock.interactions.append(interaction)
}

// MARK: - Verification

public func verify<Interaction: Equatable, S: SequenceType where S.Generator.Element == Interaction>(mock: Mock<Interaction>, interactions: S) -> Bool {
    var generator = interactions.generate()
    var element = generator.next()

    for interaction in mock.interactions {
        if interaction == element {
            element = generator.next()
        }
    }

    return element == nil
}
