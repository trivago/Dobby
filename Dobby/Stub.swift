/// A matcher-based behavior with closure-based handling.
private struct Behavior<Interaction, ReturnValue> {
    /// The matcher of this behavior.
    private let matcher: Matcher<Interaction>

    /// The handler of this behavior.
    private let handler: Interaction -> ReturnValue

    /// Initializes a new behavior with the given matcher and handler.
    private init<M: MatcherConvertible where M.ValueType == Interaction>(matcher: M, handler: Interaction -> ReturnValue) {
        self.matcher = matcher.matcher()
        self.handler = handler
    }
}

/// A stub that, when invoked, returns a value based on the set up behavior, or,
/// if an interaction is unexpected, returns nil.
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
    public func on<M: MatcherConvertible where M.ValueType == Interaction>(matcher: M, invoke handler: Interaction -> ReturnValue) -> Disposable {
        let identifier = currentIdentifier++
        behaviors.append(identifier: identifier, behavior: Behavior(matcher: matcher, handler: handler))

        return Disposable { [weak self] in
            for var index = 0; index < self?.behaviors.count; index++ {
                if self?.behaviors[index].identifier == identifier {
                    self?.behaviors.removeAtIndex(index)
                    return
                }
            }
        }
    }

    /// Modifies the behavior of this stub, returning the given value upon
    /// invocation if the given matcher does match an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this behavior.
    ///
    /// - SeeAlso: `Stub.on<M>(matcher: M, invoke: Interaction -> ReturnValue) -> Disposable`
    public func on<M: MatcherConvertible where M.ValueType == Interaction>(matcher: M, returnValue: ReturnValue) -> Disposable {
        return on(matcher) { _ in returnValue }
    }

    /// Invokes this stub, returning a value based on the set up behavior, or,
    /// if the given interaction is unexpected, returning nil.
    ///
    /// Behavior is matched in order, i.e., the function associated with the
    /// first matcher that matches the given interaction is invoked.
    public func invoke(interaction: Interaction) -> ReturnValue? {
        for (_, behavior) in behaviors {
            if behavior.matcher.matches(interaction) {
                return behavior.handler(interaction)
            }
        }

        return nil
    }
}
