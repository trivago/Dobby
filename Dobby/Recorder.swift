/// A timestamp in a logical clock.
public typealias Timestamp = UInt64

private var timestamp: Timestamp = 0
private let timestampQueue = DispatchQueue(label: "com.trivago.dobby-timestampQueue", attributes: .concurrent)

/// Returns the current timestamp of the global clock.
public var currentTimestamp: Timestamp {
    return timestampQueue.sync(execute: {
        return timestamp
    })
}

/// Advances the current timestamp of the global clock and returns it.
public func nextTimestamp() -> Timestamp {
    return timestampQueue.sync(flags: .barrier, execute: {
        timestamp += 1
        return timestamp
    })
}

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

    /// The file in which the interaction occurred.
    public let file: StaticString

    /// The line at which the interaction occurred.
    public let line: UInt

    /// Creates a new interaction with the given value at the specified time.
    public init(value: Value, timestamp: Timestamp, file: StaticString, line: UInt) {
        self.timestamp = timestamp
        self.value = value

        self.file = file
        self.line = line
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
    private var _interactions: [Interaction<Value>] = []
    private let _interactionsQueue = DispatchQueue(label: "com.trivago.dobby.recorder-interactionsQueue", attributes: .concurrent)

    public var interactions: [Interaction<Value>] {
        return _interactionsQueue.sync(execute: {
            return _interactions
        })
    }

    /// Creates a new recorder.
    public init() {

    }

    /// Records an interaction with the given value at the current timestamp of
    /// the global clock.
    public func record(_ value: Value, file: StaticString = #file, line: UInt = #line) {
        _interactionsQueue.sync(flags: .barrier, execute: {
            let interaction = Interaction(value: value, timestamp: nextTimestamp(), file: file, line: line)
            _interactions.append(interaction)
        })
    }
}
