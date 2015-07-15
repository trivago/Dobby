public enum StubError<Interaction>: ErrorType {
    case UnexpectedInteraction(Interaction)
}

public final class Stub<Interaction, ReturnValue> {
    private typealias Behavior = (identifier: UInt, expectation: Expectation<Interaction>, returnValueForInteraction: Interaction -> ReturnValue)

    private var currentIdentifier: UInt = 0
    private var behavior: [Behavior] = []

    public init() {
        
    }

    public func on<E: ExpectationConvertible where E.InteractionType == Interaction>(expectation: E, invoke returnValueForInteraction: Interaction -> ReturnValue) -> Disposable {
        let identifier = currentIdentifier++
        behavior.append((identifier, expectation.expectation(), returnValueForInteraction))

        return Disposable { [weak self] in
            guard let index = self?.behavior.indexOf({ $0.identifier == identifier }) else { return }
            self?.behavior.removeAtIndex(index)
        }
    }

    public func on<E: ExpectationConvertible where E.InteractionType == Interaction>(expectation: E, returnValue: ReturnValue) -> Disposable {
        return on(expectation) { _ in returnValue }
    }

    public func invoke(interaction: Interaction) throws -> ReturnValue {
        for (_, expectation, returnValueForInteraction) in behavior {
            if expectation.matches(interaction) {
                return returnValueForInteraction(interaction)
            }
        }

        throw StubError.UnexpectedInteraction(interaction)
    }
}
