public class Stub<Interaction: Equatable, ReturnValue> {
    public var behavior: [(interaction: Interaction, returnValue: ReturnValue)] = []

    public init() {}
}

// MARK: - Basics

public func behave<Interaction: Equatable, ReturnValue>(stub: Stub<Interaction, ReturnValue>, interaction: Interaction, returnValue: ReturnValue) {
    stub.behavior.append((interaction: interaction, returnValue: returnValue))
}

// MARK: - Invocation

public func invoke<Interaction: Equatable, ReturnValue>(stub: Stub<Interaction, ReturnValue>, interaction: Interaction) -> ReturnValue? {
    for entry in stub.behavior {
        if entry.interaction == interaction {
            return entry.returnValue
        }
    }

    return nil
}
