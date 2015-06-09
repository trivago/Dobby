public class Mock<Interaction: Equatable> {
    public var interactions: [Interaction] = []

    public init() {

    }

    public func record(interaction: Interaction) {
        interactions.append(interaction)
    }

    public func contains(interactions: [Interaction]) -> Bool {
        return self.interactions.reduce(ArraySlice(interactions)) { interactions, interaction in
            if interactions.first == interaction {
                return interactions[1..<interactions.count]
            } else {
                return interactions
            }
        }.isEmpty
    }
}
