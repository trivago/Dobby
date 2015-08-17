/// An expectation that can be matched with a value.
public struct Expectation<Value>: Printable {
    public private(set) var description: String

    private let matchesFunc: Value -> Bool

    /// Initializes a new expectation with the given description and matching
    /// function.
    public init(description: String = "<func>", matches matchesFunc: Value -> Bool) {
        self.description = description
        self.matchesFunc = matchesFunc
    }

    /// Checks whether this expectation matches the given value.
    public func matches(value: Value) -> Bool {
        return matchesFunc(value)
    }
}

/// Returns a new expectation with the given matching function.
///
/// - SeeAlso: `Expectation.init<Value>(description: String, matches: Value -> Bool)`
public func matches<Value>(matches: Value -> Bool) -> Expectation<Value> {
    return Expectation(matches: matches)
}

/// Returns a new expectation that matches anything.
public func any<Value>() -> Expectation<Value> {
    return Expectation(description: "_") { _ in true }
}

/// Returns a new expectation that matches nothing (in the sense of nil).
public func none<Value>() -> Expectation<Value?> {
    return Expectation(description: "nil") { actualValue in
        return (actualValue ?? nil) == nil
    }
}

/// Returns a new expectation that matches something (in the sense of whatever
/// the given expectation matches).
public func some<E: ExpectationConvertible>(expectation: E) -> Expectation<E.ValueType?> {
    let actualExpectation = expectation.expectation()
    return Expectation(description: actualExpectation.description) { actualValue in
        if let actualValue = actualValue {
            return actualExpectation.matches(actualValue)
        }

        return false
    }
}

/// Returns a new expectation that matches the given value.
public func equals<Value: Equatable>(value: Value) -> Expectation<Value> {
    return Expectation(description: "\(value)") { actualValue in
        return value == actualValue
    }
}

/// Returns a new expectation that matches the given 2-tuple.
public func equals<A: Equatable, B: Equatable>(values: (A, B)) -> Expectation<(A, B)> {
    return Expectation(description: "\(values)") { actualValues in
        return values.0 == actualValues.0
            && values.1 == actualValues.1
    }
}

/// Returns a new expectation that matches the given 3-tuple.
public func equals<A: Equatable, B: Equatable, C: Equatable>(values: (A, B, C)) -> Expectation<(A, B, C)> {
    return Expectation(description: "\(values)") { actualValues in
        return values.0 == actualValues.0
            && values.1 == actualValues.1
            && values.2 == actualValues.2
    }
}

/// Returns a new expectation that matches the given 4-tuple.
public func equals<A: Equatable, B: Equatable, C: Equatable, D: Equatable>(values: (A, B, C, D)) -> Expectation<(A, B, C, D)> {
    return Expectation(description: "\(values)") { actualValues in
        return values.0 == actualValues.0
            && values.1 == actualValues.1
            && values.2 == actualValues.2
            && values.3 == actualValues.3
    }
}

/// Returns a new expectation that matches the given 5-tuple.
public func equals<A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable>(values: (A, B, C, D, E)) -> Expectation<(A, B, C, D, E)> {
    return Expectation(description: "\(values)") { actualValues in
        // Expression was too complex to be solved in reasonable time; [...]
        let equals = values.0 == actualValues.0
            && values.1 == actualValues.1
            && values.2 == actualValues.2
            && values.3 == actualValues.3
            && values.4 == actualValues.4
        return equals
    }
}

/// Returns a new expectation that matches the given array.
public func equals<Element: Equatable>(value: [Element]) -> Expectation<[Element]> {
    return Expectation(description: "\(value)") { actualValue in
        return value == actualValue
    }
}

/// Returns a new expectation that matches the given dictionary.
public func equals<Key: Equatable, Value: Equatable>(value: [Key: Value]) -> Expectation<[Key: Value]> {
    return Expectation(description: "\(value)") { actualValue in
        return value == actualValue
    }
}

/// Conforming types can be converted to an expectation.
public protocol ExpectationConvertible {
    /// The type of value with which this type, when converted to an
    /// expectation, can be matched.
    typealias ValueType

    /// Converts this type to an expectation.
    func expectation() -> Expectation<ValueType>
}

extension Expectation: ExpectationConvertible {
    public func expectation() -> Expectation<Value> {
        return self
    }
}

/// Returns a new expectation that matches the given 2-tuple of expectations.
public func matches<A: ExpectationConvertible, B: ExpectationConvertible>(values: (A, B)) -> Expectation<(A.ValueType, B.ValueType)> {
    return Expectation(description: "\(values)") { actualValues in
        return values.0.expectation().matches(actualValues.0)
            && values.1.expectation().matches(actualValues.1)
    }
}

/// Returns a new expectation that matches the given 3-tuple of expectations.
public func matches<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible>(values: (A, B, C)) -> Expectation<(A.ValueType, B.ValueType, C.ValueType)> {
    return Expectation(description: "\(values)") { actualValues in
        return values.0.expectation().matches(actualValues.0)
            && values.1.expectation().matches(actualValues.1)
            && values.2.expectation().matches(actualValues.2)
    }
}

/// Returns a new expectation that matches the given 4-tuple of expectations.
public func matches<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible, D: ExpectationConvertible>(values: (A, B, C, D)) -> Expectation<(A.ValueType, B.ValueType, C.ValueType, D.ValueType)> {
    return Expectation(description: "\(values)") { actualValues in
        return values.0.expectation().matches(actualValues.0)
            && values.1.expectation().matches(actualValues.1)
            && values.2.expectation().matches(actualValues.2)
            && values.3.expectation().matches(actualValues.3)
    }
}

/// Returns a new expectation that matches the given 5-tuple of expectations.
public func matches<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible, D: ExpectationConvertible, E: ExpectationConvertible>(values: (A, B, C, D, E)) -> Expectation<(A.ValueType, B.ValueType, C.ValueType, D.ValueType, E.ValueType)> {
    return Expectation(description: "\(values)") { actualValues in
        return values.0.expectation().matches(actualValues.0)
            && values.1.expectation().matches(actualValues.1)
            && values.2.expectation().matches(actualValues.2)
            && values.3.expectation().matches(actualValues.3)
            && values.4.expectation().matches(actualValues.4)
    }
}

/// Returns a new expectation that matches the given array of expectations.
public func matches<Element: ExpectationConvertible>(values: [Element]) -> Expectation<[Element.ValueType]> {
    return Expectation(description: "\(values)") { actualValues in
        if values.count != actualValues.count {
            return false
        }

        for (element, actualElement) in zip(values, actualValues) {
            if !element.expectation().matches(actualElement) {
                return false
            }
        }

        return true
    }
}

/// Returns a new expectation that matches the given dictionary of expectations.
public func matches<Key: Hashable, Value: ExpectationConvertible>(values: [Key: Value]) -> Expectation<[Key: Value.ValueType]> {
    return Expectation(description: "\(values)") { actualValues in
        if values.count != actualValues.count {
            return false
        }

        for (key, value) in values {
            if !(actualValues[key].map { actualValue in value.expectation().matches(actualValue) } ?? false) {
                return false
            }
        }

        return true
    }
}
