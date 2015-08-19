/// A closure-based matcher.
public struct Matcher<Value>: CustomStringConvertible {
    public let description: String

    /// The matching function of this matcher.
    public let matches: Value -> Bool

    /// Initializes a new matcher with the given description and matching
    /// function.
    public init(description: String = "<func>", matches: Value -> Bool) {
        self.description = description
        self.matches = matches
    }
}

/// Returns a new matcher with the given matching function.
///
/// - SeeAlso: `Matcher.init<Value>(description: String, matches: Value -> Bool)`
public func matches<Value>(matches: Value -> Bool) -> Matcher<Value> {
    return Matcher(matches: matches)
}

public extension Matcher {
    /// Initializes a new matcher that matches anything.
    public init() {
        self.init(description: "_") { _ in true }
    }
}

/// Returns a new matcher that matches anything.
public func any<Value>() -> Matcher<Value> {
    return Matcher()
}

/// Returns a new matcher that matches anything but whatever the given matcher
/// does match.
public func not<M: MatcherConvertible>(matcher: M) -> Matcher<M.ValueType> {
    let actualMatcher = matcher.matcher()

    return Matcher(description: "not(\(actualMatcher))") { actualValue in
        return actualMatcher.matches(actualValue) == false
    }
}

/// Returns a new matcher that matches nothing (in the sense of nil).
public func none<Value>() -> Matcher<Value?> {
    return Matcher(description: "nil") { actualValue in
        return actualValue == nil
    }
}

/// Returns a new matcher that matches something (in the sense of whatever
/// the given matcher does match).
public func some<M: MatcherConvertible>(matcher: M) -> Matcher<M.ValueType?> {
    let actualMatcher = matcher.matcher()

    return Matcher(description: actualMatcher.description) { actualValue in
        if let actualValue = actualValue {
            return actualMatcher.matches(actualValue)
        }

        return false
    }
}

public extension Matcher where Value: Equatable {
    /// Initializes a new matcher that matches the given value.
    public init(value: Value) {
        self.init(description: "\(value)") { actualValue in
            return value == actualValue
        }
    }
}

/// Returns a new matcher that matches the given value.
public func equals<Value: Equatable>(value: Value) -> Matcher<Value> {
    return Matcher(value: value)
}

/// Returns a new matcher that matches the given 2-tuple.
public func equals<A: Equatable, B: Equatable>(values: (A, B)) -> Matcher<(A, B)> {
    return Matcher(description: "\(values)") { actualValues in
        return values.0 == actualValues.0
            && values.1 == actualValues.1
    }
}

/// Returns a new matcher that matches the given 3-tuple.
public func equals<A: Equatable, B: Equatable, C: Equatable>(values: (A, B, C)) -> Matcher<(A, B, C)> {
    return Matcher(description: "\(values)") { actualValues in
        return values.0 == actualValues.0
            && values.1 == actualValues.1
            && values.2 == actualValues.2
    }
}

/// Returns a new matcher that matches the given 4-tuple.
public func equals<A: Equatable, B: Equatable, C: Equatable, D: Equatable>(values: (A, B, C, D)) -> Matcher<(A, B, C, D)> {
    return Matcher(description: "\(values)") { actualValues in
        // Expression was too complex to be solved in reasonable time; [...]
        let equals = values.0 == actualValues.0
            && values.1 == actualValues.1
            && values.2 == actualValues.2
            && values.3 == actualValues.3
        return equals
    }
}

/// Returns a new matcher that matches the given 5-tuple.
public func equals<A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable>(values: (A, B, C, D, E)) -> Matcher<(A, B, C, D, E)> {
    return Matcher(description: "\(values)") { actualValues in
        // Expression was too complex to be solved in reasonable time; [...]
        let equals = values.0 == actualValues.0
            && values.1 == actualValues.1
            && values.2 == actualValues.2
            && values.3 == actualValues.3
            && values.4 == actualValues.4
        return equals
    }
}

/// Returns a new matcher that matches the given array.
public func equals<Element: Equatable>(value: [Element]) -> Matcher<[Element]> {
    return Matcher(description: "\(value)") { actualValue in
        return value == actualValue
    }
}

/// Returns a new matcher that matches the given dictionary.
public func equals<Key: Equatable, Value: Equatable>(value: [Key: Value]) -> Matcher<[Key: Value]> {
    return Matcher(description: "\(value)") { actualValue in
        return value == actualValue
    }
}

/// Conforming types can be converted to a matcher.
public protocol MatcherConvertible {
    /// The type of value this type, when converted to a matcher, does match.
    typealias ValueType

    /// Converts this type to a matcher.
    func matcher() -> Matcher<ValueType>
}

extension Matcher: MatcherConvertible {
    public func matcher() -> Matcher<Value> {
        return self
    }
}

/// Returns a new matcher that matches the given 2-tuple of matchers.
public func matches<A: MatcherConvertible, B: MatcherConvertible>(values: (A, B)) -> Matcher<(A.ValueType, B.ValueType)> {
    return Matcher(description: "\(values)") { actualValues in
        return values.0.matcher().matches(actualValues.0)
            && values.1.matcher().matches(actualValues.1)
    }
}

/// Returns a new matcher that matches the given 3-tuple of matchers.
public func matches<A: MatcherConvertible, B: MatcherConvertible, C: MatcherConvertible>(values: (A, B, C)) -> Matcher<(A.ValueType, B.ValueType, C.ValueType)> {
    return Matcher(description: "\(values)") { actualValues in
        return values.0.matcher().matches(actualValues.0)
            && values.1.matcher().matches(actualValues.1)
            && values.2.matcher().matches(actualValues.2)
    }
}

/// Returns a new matcher that matches the given 4-tuple of matchers.
public func matches<A: MatcherConvertible, B: MatcherConvertible, C: MatcherConvertible, D: MatcherConvertible>(values: (A, B, C, D)) -> Matcher<(A.ValueType, B.ValueType, C.ValueType, D.ValueType)> {
    return Matcher(description: "\(values)") { actualValues in
        return values.0.matcher().matches(actualValues.0)
            && values.1.matcher().matches(actualValues.1)
            && values.2.matcher().matches(actualValues.2)
            && values.3.matcher().matches(actualValues.3)
    }
}

/// Returns a new matcher that matches the given 5-tuple of matchers.
public func matches<A: MatcherConvertible, B: MatcherConvertible, C: MatcherConvertible, D: MatcherConvertible, E: MatcherConvertible>(values: (A, B, C, D, E)) -> Matcher<(A.ValueType, B.ValueType, C.ValueType, D.ValueType, E.ValueType)> {
    return Matcher(description: "\(values)") { actualValues in
        return values.0.matcher().matches(actualValues.0)
            && values.1.matcher().matches(actualValues.1)
            && values.2.matcher().matches(actualValues.2)
            && values.3.matcher().matches(actualValues.3)
            && values.4.matcher().matches(actualValues.4)
    }
}

/// Returns a new matcher that matches the given array of matchers.
public func matches<Element: MatcherConvertible>(values: [Element]) -> Matcher<[Element.ValueType]> {
    return Matcher(description: "\(values)") { actualValues in
        guard values.count == actualValues.count else { return false }

        for (element, actualElement) in zip(values, actualValues) {
            if element.matcher().matches(actualElement) == false {
                return false
            }
        }

        return true
    }
}

/// Returns a new matcher that matches the given dictionary of matchers.
public func matches<Key: Hashable, Value: MatcherConvertible>(values: [Key: Value]) -> Matcher<[Key: Value.ValueType]> {
    return Matcher(description: "\(values)") { actualValues in
        guard values.count == actualValues.count else { return false }

        for (key, value) in values {
            guard let actualValue = actualValues[key] else { return false }

            if value.matcher().matches(actualValue) == false {
                return false
            }
        }

        return true
    }
}
