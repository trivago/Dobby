//  Copyright (c) 2015 Rheinfabrik. All rights reserved.

import Box

public protocol ArgumentConvertible: Equatable {
    typealias ArgumentType: Equatable

    func argument() -> Argument<ArgumentType>
}

public enum Argument<T: Equatable>: Equatable {
    case Filter(Box<T -> Bool>)
    case Value(Box<T>)
    case Any
}

extension Argument: ArgumentConvertible {
    public func argument() -> Argument<T> {
        return self
    }
}

// MARK: - Equality

public func == <T: Equatable>(lhs: Argument<T>, rhs: Argument<T>) -> Bool {
    switch (lhs, rhs) {
    case let (.Value(left), .Value(right)):
        return left.value == right.value
    case let (.Value(value), .Filter(f)):
        return f.value(value.value)
    case let (.Filter(f), .Value(value)):
        return f.value(value.value)
    case (.Any, _), (_, .Any):
        return true
    default:
        return false
    }
}

// MARK: - Basics

public func filter<T: Equatable>(f: T -> Bool) -> Argument<T> {
    return .Filter(Box(f))
}

public func value<T: Equatable>(value: T) -> Argument<T> {
    return .Value(Box(value))
}

public func any<T: Equatable>() -> Argument<T> {
    return .Any
}
