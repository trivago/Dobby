/// A stub that, when invoked, returns a value based on the set up behavior, or,
/// if an interaction is unexpected, returns nil.
public final class Stub<Interaction, ReturnValue> {
    private typealias Behavior = (identifier: UInt, matcher: Matcher<Interaction>, returnValueForInteraction: Interaction -> ReturnValue)

    private var currentIdentifier: UInt = 0
    private var behavior: [Behavior] = []

    /// Initializes a new stub.
    public init() {
        
    }

    /// Modifies the behavior of this stub, forwarding invocations to the given
    /// function and returning its return value if the given matcher does match
    /// an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this behavior.
    public func on<M: MatcherConvertible where M.ValueType == Interaction>(matcher: M, invoke returnValueForInteraction: Interaction -> ReturnValue) -> Disposable {
        let identifier = currentIdentifier++
        behavior.append((identifier, matcher.matcher(), returnValueForInteraction))

        return Disposable { [weak self] in
            for var index = 0; index < self?.behavior.count; index++ {
                if self?.behavior[index].identifier == identifier {
                    self?.behavior.removeAtIndex(index)
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
        for (_, matcher, returnValueForInteraction) in behavior {
            if matcher.matches(interaction) {
                return returnValueForInteraction(interaction)
            }
        }

        return nil
    }
}
