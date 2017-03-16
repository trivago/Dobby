/// A matcher-based reaction with closure-based handling.
fileprivate struct Reaction<Value, ReturnValue> {
    /// The matcher of this reaction.
    fileprivate let matcher: Matcher<Value>

    /// The handler of this reaction.
    fileprivate let handler: (Value) throws -> ReturnValue

    /// Initializes a new reaction with the given matcher and handler.
    fileprivate init<Matcher: MatcherConvertible>(matcher: Matcher, handler: @escaping (Value) throws -> ReturnValue) where Matcher.ValueType == Value {
        self.matcher = matcher.matcher()
        self.handler = handler
    }
}

/// A behavior error.
public enum BehaviorError<Value, ReturnValue>: Error {
    /// An interaction with the associated value was unexpected.
    case unexpectedInteraction(Value)
}

/// A behavior that, when invoked, returns a value based on the set up
/// reactions, or, if an interaction is unexpected, throws an error.
public final class Behavior<Value, ReturnValue> {
    /// The current (next) identifier for reactions.
    private var currentIdentifier: UInt = 0

    /// The reactions of this behavior.
    private var reactions: [(identifier: UInt, reaction: Reaction<Value, ReturnValue>)] = []

    /// The recorder of this behavior.
    fileprivate let recorder: Recorder<Value> = Recorder()

    /// Creates a new behavior.
    public init() {
        
    }

    /// Modifies the reactions of this behavior, forwarding invocations to the
    /// given handler and returning its return value if the given matcher does
    /// match an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this reaction.
    @discardableResult
    public func on<Matcher: MatcherConvertible>(_ matcher: Matcher, invoke handler: @escaping (Value) throws -> ReturnValue) -> Disposable where Matcher.ValueType == Value {
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

    /// Modifies the reactions of this behavior, returning the given value upon
    /// invocation if the given matcher does match an interaction.
    ///
    /// Returns a disposable that, when disposed, removes this reaction.
    ///
    /// - SeeAlso: `Behavior.on<Matcher>(matcher: Matcher, invoke: (Value) -> ReturnValue) -> Disposable`
    @discardableResult
    public func on<Matcher: MatcherConvertible>(_ matcher: Matcher, return value: ReturnValue) -> Disposable where Matcher.ValueType == Value {
        return on(matcher) { _ in value }
    }

    /// Invokes this behavior, returning a value based on the set up reactions,
    /// or, if the given interaction is unexpected, throwing an error.
    ///
    /// Reactions are matched in order, i.e., the handler associated with the
    /// first matcher that matches the given interaction is invoked.
    ///
    /// - Throws: `BehaviorError.unexpectedInteraction(Value)` if the given
    ///     interaction is unexpected.
    @discardableResult
    public func invoke(_ value: Value) throws -> ReturnValue {
        recorder.record(value)

        for (_, reaction) in reactions {
            if reaction.matcher.matches(value) {
                return try reaction.handler(value)
            }
        }

        throw BehaviorError<Value, ReturnValue>.unexpectedInteraction(value)
    }
}

extension Behavior: ValueRecording {
    public var interactions: AnyRandomAccessCollection<Interaction> {
        return recorder.interactions
    }

    public func valueForInteraction(at index: Int) -> Value {
        return recorder.valueForInteraction(at: index)
    }
}
