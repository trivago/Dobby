/// A stub error.
public enum StubError<Interaction>: ErrorType {
    /// The associated interaction was unexpected.
    case UnexpectedInteraction(Interaction)
}

/// A stub that, when invoked, returns a value based on the set up behavior, or,
/// if an interaction is unexpected, throws an error.
public final class Stub<Interaction, ReturnValue> {
    private typealias Behavior = (identifier: UInt, expectation: Expectation<Interaction>, returnValueForInteraction: Interaction -> ReturnValue)

    private var currentIdentifier: UInt = 0
    private var behavior: [Behavior] = []

    /// Initializes a new stub.
    public init() {
        
    }

    /// Modifies the behavior of this stub, forwarding invocations to the given
    /// function and returning its return value if the given expectation is
    /// matched with an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this behavior.
    public func on<E: ExpectationConvertible where E.InteractionType == Interaction>(expectation: E, invoke returnValueForInteraction: Interaction -> ReturnValue) -> Disposable {
        let identifier = currentIdentifier++
        behavior.append((identifier, expectation.expectation(), returnValueForInteraction))

        return Disposable { [weak self] in
            guard let index = self?.behavior.indexOf({ $0.identifier == identifier }) else { return }
            self?.behavior.removeAtIndex(index)
        }
    }

    /// Modifies the behavior of this stub, returning the given value upon
    /// invocation if the given expectation is matched with an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this behavior.
    ///
    /// - SeeAlso: `Stub.on<E>(expectation: E, invoke: Interaction -> ReturnValue) -> Disposable`
    public func on<E: ExpectationConvertible where E.InteractionType == Interaction>(expectation: E, returnValue: ReturnValue) -> Disposable {
        return on(expectation) { _ in returnValue }
    }

    /// Invokes this stub, returning a value based on the set up behavior, or,
    /// if the given interaction is unexpected, throwing an error.
    ///
    /// Behavior is matched in order, i.e., the function associated with the
    /// first expectation that matches the given interaction is invoked.
    ///
    /// - Throws: `StubError.UnexpectedInteraction(Interaction)` if the given
    ///     interaction is unexpected.
    public func invoke(interaction: Interaction) throws -> ReturnValue {
        for (_, expectation, returnValueForInteraction) in behavior {
            if expectation.matches(interaction) {
                return returnValueForInteraction(interaction)
            }
        }

        throw StubError.UnexpectedInteraction(interaction)
    }
}
