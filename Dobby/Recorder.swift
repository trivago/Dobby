/// A timestamp in a logical clock.
public typealias Timestamp = UInt64

/// The current timestamp of the global clock.
internal var currentTimestamp: Timestamp = 0

/// A type that provides chronological access to recorded timestamps.
public protocol TimestampRecording: class {
    /// Returns the recorded timestamps in chronological order.
    var timestamps: [Timestamp] { get }
}

/// An interaction, consisting of a timestamp and a value.
public struct Interaction<Value> {
    /// The time when the interaction occurred.
    public let timestamp: Timestamp

    /// The value of the interaction.
    public let value: Value

    /// Creates a new interaction with the given value at the specified time.
    public init(value: Value, at timestamp: Timestamp) {
        self.timestamp = timestamp
        self.value = value
    }
}

/// A type that provides chronological access to recorded interactions.
public protocol InteractionRecording: TimestampRecording {
    /// The value type of recorded interactions.
    associatedtype Value

    /// Returns the recorded interactions in chronological order.
    var interactions: [Interaction<Value>] { get }
}

public extension InteractionRecording {
    public var timestamps: [Timestamp] {
        return interactions.map({ interaction in
            return interaction.timestamp
        })
    }
}

/// A recorder for interactions of the specified value type.
public final class Recorder<Value>: InteractionRecording {
    public private(set) var interactions: [Interaction<Value>] = []

    /// Creates a new recorder.
    public init() {

    }

    /// Records an interaction with the given value at the current timestamp of
    /// the global clock.
    public func record(_ value: Value) {
        let interaction = Interaction(value: value, at: currentTimestamp)
        interactions.append(interaction)

        // Advance the global clock.
        currentTimestamp += 1
    }
}
