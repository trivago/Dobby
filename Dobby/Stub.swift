public class Stub<Interaction: Equatable, ReturnValue> {
    public var behavior: [(interaction: Interaction, returnValue: ReturnValue)] = []

    public init() {

    }

    public func behave(interaction: Interaction, _ returnValue: ReturnValue) {
        behavior.append((interaction: interaction, returnValue: returnValue))
    }

    public func invoke(interaction: Interaction) -> ReturnValue? {
        for entry in behavior {
            if entry.interaction == interaction {
                return entry.returnValue
            }
        }

        return nil
    }
}
