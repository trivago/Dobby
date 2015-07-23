/// An expectation that can be matched with an interaction.
public struct Expectation<Interaction>: CustomStringConvertible {
    public private(set) var description: String

    private let matchesFunc: Interaction -> Bool

    /// Initializes a new expectation with the given description and matching
    /// function.
    public init(description: String = "<func>", matches matchesFunc: Interaction -> Bool) {
        self.description = description
        self.matchesFunc = matchesFunc
    }

    /// Checks whether the given interaction matches this expectation.
    public func matches(interaction: Interaction) -> Bool {
        return matchesFunc(interaction)
    }
}

/// Returns a new expectation with the given matching function.
///
/// - SeeAlso: `Expectation.init<Interaction>(description: String, matches: Interaction -> Bool)`
public func matches<Interaction>(matches: Interaction -> Bool) -> Expectation<Interaction> {
    return Expectation(matches: matches)
}

public extension Expectation {
    /// Initializes a new expectation that matches anything.
    public init() {
        self.init(description: "_") { _ in true }
    }
}

/// Returns a new expectation that matches anything.
///
/// - SeeAlso: `Expectation.init<Interaction>()`
public func any<Interaction>() -> Expectation<Interaction> {
    return Expectation()
}

public extension Expectation where Interaction: Equatable {
    public typealias Value = Interaction

    /// Initializes a new expectation that matches the given value.
    public init(value: Value) {
        self.init(description: "\(value)") { $0 == value }
    }
}

/// Returns a new expectation that matches the given value.
///
/// - SeeAlso: `Expectation.init<Interaction>(value: Value)`
public func equals<Value: Equatable>(value: Value) -> Expectation<Value> {
    return Expectation(value: value)
}

/// Returns a new expectation that matches the given 2-tuple.
public func equals<A: Equatable, B: Equatable>(tuple: (A, B)) -> Expectation<(A, B)> {
    return Expectation(description: "\(tuple)") { interaction in
        return tuple.0 == interaction.0
            && tuple.1 == interaction.1
    }
}

/// Returns a new expectation that matches the given 3-tuple.
public func equals<A: Equatable, B: Equatable, C: Equatable>(tuple: (A, B, C)) -> Expectation<(A, B, C)> {
    return Expectation(description: "\(tuple)") { interaction in
        return tuple.0 == interaction.0
            && tuple.1 == interaction.1
            && tuple.2 == interaction.2
    }
}

/// Returns a new expectation that matches the given 4-tuple.
public func equals<A: Equatable, B: Equatable, C: Equatable, D: Equatable>(tuple: (A, B, C, D)) -> Expectation<(A, B, C, D)> {
    return Expectation(description: "\(tuple)") { interaction in
        return tuple.0 == interaction.0
            && tuple.1 == interaction.1
            && tuple.2 == interaction.2
            && tuple.3 == interaction.3
    }
}

/// Returns a new expectation that matches the given 5-tuple.
public func equals<A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable>(tuple: (A, B, C, D, E)) -> Expectation<(A, B, C, D, E)> {
    return Expectation(description: "\(tuple)") { interaction in
        // Expression was too complex to be solved in reasonable time; [...]
        let equals = tuple.0 == interaction.0
            && tuple.1 == interaction.1
            && tuple.2 == interaction.2
            && tuple.3 == interaction.3
            && tuple.4 == interaction.4
        return equals
    }
}

/// Returns a new expectation that matches the given array.
public func equals<Element: Equatable>(array: [Element]) -> Expectation<[Element]> {
    return Expectation(description: "\(array)") { $0 == array }
}

/// Returns a new expectation that matches the given dictionary.
public func equals<Key: Equatable, Value: Equatable>(dictionary: [Key: Value]) -> Expectation<[Key: Value]> {
    return Expectation(description: "\(dictionary)") { $0 == dictionary }
}

/// Conforming types can be converted to an expectation.
public protocol ExpectationConvertible {
    /// The type of interaction with which this type, when converted to an
    /// expectation, can be matched.
    typealias InteractionType

    /// Converts this type to an expectation.
    func expectation() -> Expectation<InteractionType>
}

extension Expectation: ExpectationConvertible {
    public func expectation() -> Expectation<Interaction> {
        return self
    }
}

/// Returns a new expectation that matches the given 2-tuple of expectations.
public func matches<A: ExpectationConvertible, B: ExpectationConvertible>(tuple: (A, B)) -> Expectation<(A.InteractionType, B.InteractionType)> {
    return Expectation(description: "\(tuple)") { interaction in
        return tuple.0.expectation().matches(interaction.0)
            && tuple.1.expectation().matches(interaction.1)
    }
}

/// Returns a new expectation that matches the given 3-tuple of expectations.
public func matches<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible>(tuple: (A, B, C)) -> Expectation<(A.InteractionType, B.InteractionType, C.InteractionType)> {
    return Expectation(description: "\(tuple)") { interaction in
        return tuple.0.expectation().matches(interaction.0)
            && tuple.1.expectation().matches(interaction.1)
            && tuple.2.expectation().matches(interaction.2)
    }
}

/// Returns a new expectation that matches the given 4-tuple of expectations.
public func matches<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible, D: ExpectationConvertible>(tuple: (A, B, C, D)) -> Expectation<(A.InteractionType, B.InteractionType, C.InteractionType, D.InteractionType)> {
    return Expectation(description: "\(tuple)") { interaction in
        return tuple.0.expectation().matches(interaction.0)
            && tuple.1.expectation().matches(interaction.1)
            && tuple.2.expectation().matches(interaction.2)
            && tuple.3.expectation().matches(interaction.3)
    }
}

/// Returns a new expectation that matches the given 5-tuple of expectations.
public func matches<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible, D: ExpectationConvertible, E: ExpectationConvertible>(tuple: (A, B, C, D, E)) -> Expectation<(A.InteractionType, B.InteractionType, C.InteractionType, D.InteractionType, E.InteractionType)> {
    return Expectation(description: "\(tuple)") { interaction in
        return tuple.0.expectation().matches(interaction.0)
            && tuple.1.expectation().matches(interaction.1)
            && tuple.2.expectation().matches(interaction.2)
            && tuple.3.expectation().matches(interaction.3)
            && tuple.4.expectation().matches(interaction.4)
    }
}
