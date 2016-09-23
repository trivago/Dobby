/// A matcher-based behavior with closure-based handling.
fileprivate struct Behavior<Interaction, ReturnValue> {
    /// The matcher of this behavior.
    fileprivate let matcher: Matcher<Interaction>

    /// The handler of this behavior.
    fileprivate let handler: (Interaction) -> ReturnValue

    /// Initializes a new behavior with the given matcher and handler.
    fileprivate init<M: MatcherConvertible>(matcher: M, handler: @escaping (Interaction) -> ReturnValue) where M.ValueType == Interaction {
        self.matcher = matcher.matcher()
        self.handler = handler
    }
}

/// A stub error.
public enum StubError<Interaction, ReturnValue>: Error {
    /// The associated interaction was unexpected.
    case unexpectedInteraction(Interaction)
}

/// A stub that, when invoked, returns a value based on the set up behavior, or,
/// if an interaction is unexpected, throws an error.
public final class Stub<Interaction, ReturnValue> {
    /// The current (next) identifier for behaviors.
    private var currentIdentifier: UInt = 0

    /// The behaviors of this stub.
    private var behaviors: [(identifier: UInt, behavior: Behavior<Interaction, ReturnValue>)] = []

    /// Initializes a new stub.
    public init() {
        
    }

    /// Modifies the behavior of this stub, forwarding invocations to the given
    /// function and returning its return value if the given matcher does match
    /// an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this behavior.
    public func on<M: MatcherConvertible>(_ matcher: M, invoke handler: @escaping (Interaction) -> ReturnValue) -> Disposable where M.ValueType == Interaction {
        currentIdentifier += 1

        let identifier = currentIdentifier
        let behavior = Behavior(matcher: matcher, handler: handler)
        behaviors.append((identifier: identifier, behavior: behavior))

        return Disposable { [weak self] in
            let index = self?.behaviors.index { otherIdentifier, _ in
                return otherIdentifier == identifier
            }

            if let index = index {
                self?.behaviors.remove(at: index)
            }
        }
    }

    /// Modifies the behavior of this stub, returning the given value upon
    /// invocation if the given matcher does match an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this behavior.
    ///
    /// - SeeAlso: `Stub.on<M>(matcher: M, invoke: Interaction -> ReturnValue) -> Disposable`
    public func on<M: MatcherConvertible>(_ matcher: M, returnValue: ReturnValue) -> Disposable where M.ValueType == Interaction {
        return on(matcher) { _ in returnValue }
    }

    /// Invokes this stub, returning a value based on the set up behavior, or,
    /// if the given interaction is unexpected, throwing an error.
    ///
    /// Behavior is matched in order, i.e., the function associated with the
    /// first matcher that matches the given interaction is invoked.
    ///
    /// - Throws: `StubError.UnexpectedInteraction(Interaction)` if the given
    ///     interaction is unexpected.
    public func invoke(_ interaction: Interaction) throws -> ReturnValue {
        for (_, behavior) in behaviors {
            if behavior.matcher.matches(interaction) {
                return behavior.handler(interaction)
            }
        }

        throw StubError<Interaction, ReturnValue>.unexpectedInteraction(interaction)
    }
}
