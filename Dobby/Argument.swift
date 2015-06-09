public protocol ArgumentConvertible {
    typealias ArgumentType: Equatable

    func argument() -> Argument<ArgumentType>
}

public enum Argument<T: Equatable>: Equatable {
    case Filter(T -> Bool)
    case Value(T)
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
        return left == right
    case let (.Value(value), .Filter(f)):
        return f(value)
    case let (.Filter(f), .Value(value)):
        return f(value)
    case (.Any, _), (_, .Any):
        return true
    default:
        return false
    }
}

// MARK: - Basics

public func filter<T: Equatable>(f: T -> Bool) -> Argument<T> {
    return .Filter(f)
}

public func value<T: Equatable>(value: T) -> Argument<T> {
    return .Value(value)
}

public func any<T: Equatable>() -> Argument<T> {
    return .Any
}
