/// A matcher-based reaction with closure-based handling.
fileprivate struct Reaction<Value, ReturnValue> {
    /// The matcher of this reaction.
    fileprivate let matcher: Matcher<Value>

    /// The handler of this reaction.
    fileprivate let handler: (Value) -> ReturnValue

    /// Initializes a new reaction with the given matcher and handler.
    fileprivate init<Matcher: MatcherConvertible>(matcher: Matcher, handler: @escaping (Value) -> ReturnValue) where Matcher.ValueType == Value {
        self.matcher = matcher.matcher()
        self.handler = handler
    }
}

/// A stub error.
public enum StubError<Value, ReturnValue>: Error {
    /// An interaction with the associated value was unexpected.
    case unexpectedInteraction(Value)
}

/// A stub that, when invoked, returns a value based on the set up reactions,
/// or, if an interaction is unexpected, throws an error.
public final class Stub<Value, ReturnValue> {
    /// The current (next) identifier for reactions.
    private var currentIdentifier: UInt = 0

    /// The reactions of this stub.
    private var reactions: [(identifier: UInt, reaction: Reaction<Value, ReturnValue>)] = []

    /// Creates a new stub.
    public init() {
        
    }

    /// Modifies the reactions of this stub, forwarding invocations to the
    /// given handler and returning its return value if the given matcher
    /// does match an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this reaction.
    @discardableResult
    public func on<Matcher: MatcherConvertible>(_ matcher: Matcher, invoke handler: @escaping (Value) -> ReturnValue) -> Disposable where Matcher.ValueType == Value {
        currentIdentifier += 1

        let identifier = currentIdentifier
        let reaction = Reaction(matcher: matcher, handler: handler)
        reactions.append((identifier: identifier, reaction: reaction))

        return Disposable { [weak self] in
            let index = self?.reactions.index { otherIdentifier, _ in
                return otherIdentifier == identifier
            }

            if let index = index {
                self?.reactions.remove(at: index)
            }
        }
    }

    /// Modifies the reactions of this stub, returning the given value upon
    /// invocation if the given matcher does match an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this reaction.
    ///
    /// - SeeAlso: `Stub.on<Matcher>(matcher: Matcher, invoke: (Value) -> ReturnValue) -> Disposable`
    @discardableResult
    public func on<Matcher: MatcherConvertible>(_ matcher: Matcher, return value: ReturnValue) -> Disposable where Matcher.ValueType == Value {
        return on(matcher) { _ in value }
    }

    /// Invokes this stub, returning a value based on the set up reactions, or,
    /// if the given interaction is unexpected, throwing an error.
    ///
    /// Reactions are matched in order, i.e., the handler associated with the
    /// first matcher that matches the given interaction is invoked.
    ///
    /// - Throws: `StubError.unexpectedInteraction(Value)` if the given
    ///     interaction is unexpected.
    @discardableResult
    public func invoke(_ value: Value) throws -> ReturnValue {
        for (_, reaction) in reactions {
            if reaction.matcher.matches(value) {
                return reaction.handler(value)
            }
        }

        throw StubError<Value, ReturnValue>.unexpectedInteraction(value)
    }
}
