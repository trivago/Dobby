/// A timestamp in a logical clock.
public typealias Timestamp = UInt64

/// A thread-safe global logical clock.
fileprivate var timestamp: Timestamp = 0
fileprivate let timestampQueue = DispatchQueue(label: "com.trivago.dobby-timestampQueue", attributes: .concurrent)

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

/// A recorded interaction.
public struct Interaction: CustomStringConvertible {
    public let description: String

    /// The time when this interaction was recorded.
    public let timestamp: Timestamp

    /// The file in which this interaction was recorded.
    public let file: StaticString

    /// The line at which this interaction was recorded.
    public let line: UInt

    /// Creates a new interaction with the given textual representation at the
    /// specified time.
    public init(description: String, timestamp: Timestamp, file: StaticString, line: UInt) {
        self.description = description
        self.timestamp = timestamp

        self.file = file
        self.line = line
    }
}

/// A type that provides chronological access to recorded interactions.
public protocol InteractionRecording: class {
    /// Returns the unique identifier for this object.
    var objectIdentifier: ObjectIdentifier { get }

    /// Returns a random access collection that provides access to the recorded
    /// interactions in chronological order.
    var interactions: AnyRandomAccessCollection<Interaction> { get }
}

extension InteractionRecording {
    public var objectIdentifier: ObjectIdentifier {
        return ObjectIdentifier(self)
    }
}

/// A type-erased, hashable interaction recorder. The hash value and equality
/// operator are implemented using object identifiers.
internal final class AnyInteractionRecording: InteractionRecording, Hashable {
    /// The wrapped interaction recorder.
    private let base: InteractionRecording

    internal var objectIdentifier: ObjectIdentifier {
        return base.objectIdentifier
    }

    internal var interactions: AnyRandomAccessCollection<Interaction> {
        return base.interactions
    }

    internal var hashValue: Int {
        return objectIdentifier.hashValue
    }

    /// Creates a type-erased, hashable interaction recorder that wraps the
    /// given instance.
    internal init(_ base: InteractionRecording) {
        self.base = base
    }
}

internal func == (lhs: AnyInteractionRecording, rhs: AnyInteractionRecording) -> Bool {
    return lhs.objectIdentifier == rhs.objectIdentifier
}

/// A type that provides chronological access to recorded interactions and
/// corresponding values.
public protocol ValueRecording: InteractionRecording {
    /// The type of recorded values.
    associatedtype Value

    /// Returns the value corresponding to the interaction at the given index.
    func valueForInteraction(at index: Int) -> Value
}

/// A recorded entry.
fileprivate struct Entry<Value> {
    /// The recorded interaction.
    fileprivate let interaction: Interaction

    /// The recorded value.
    fileprivate let value: Value

    /// Creates a new entry with the given interaction and value.
    fileprivate init(interaction: Interaction, value: Value) {
        self.interaction = interaction
        self.value = value
    }

    /// Creates a new entry using the value's textual representation as
    /// description for the interaction.
    fileprivate init(value: Value, timestamp: Timestamp, file: StaticString, line: UInt) {
        let interaction = Interaction(description: String(describing: value), timestamp: timestamp, file: file, line: line)

        self.init(interaction: interaction, value: value)
    }
}

/// A thread-safe recorder for interactions of the specified value type.
public final class Recorder<Value> {
    fileprivate var entries: [Entry<Value>] = []
    fileprivate let entriesQueue = DispatchQueue(label: "com.trivago.dobby.recorder-entriesQueue", attributes: .concurrent)

    /// Creates a new recorder.
    public init() {

    }

    /// Records an interaction with the given value.
    public func record(_ value: Value, file: StaticString = #file, line: UInt = #line) {
        entriesQueue.sync(flags: .barrier, execute: {
            // Get the next timestamp while executing on the entries queue to
            // guarantee that entries are appended in chronological order.
            let entry = Entry(value: value, timestamp: nextTimestamp(), file: file, line: line)

            entries.append(entry)
        })
    }
}

extension Recorder: ValueRecording {
    public var interactions: AnyRandomAccessCollection<Interaction> {
        let entries = entriesQueue.sync(execute: {
            return self.entries
        })

        let interactions = entries.lazy.map({ entry in
            return entry.interaction
        })

        return AnyRandomAccessCollection(interactions)
    }

    public func valueForInteraction(at index: Int) -> Value {
        let entries = entriesQueue.sync(execute: {
            return self.entries
        })

        return entries[index].value
    }
}
