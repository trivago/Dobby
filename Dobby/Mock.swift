public class Mock<Interaction: Equatable> {
    public var interactions: [Interaction] = []

    public init() {}
}

// MARK: - Basics

public func record<Interaction: Equatable>(mock: Mock<Interaction>, interaction: Interaction) {
    mock.interactions.append(interaction)
}

// MARK: - Verification

public func contains<Interaction: Equatable>(mock: Mock<Interaction>, interactions: [Interaction]) -> Bool {
    return isEmpty(reduce(mock.interactions, ArraySlice(interactions)) { interactions, interaction in
        if interactions.first == interaction {
            return interactions[1..<count(interactions)]
        } else {
            return interactions
        }
    })
}
