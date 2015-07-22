public struct Expectation<Interaction>: CustomStringConvertible {
    public private(set) var description: String

    private let matchesFunc: Interaction -> Bool

    public init(description: String = "<func>", matches matchesFunc: Interaction -> Bool) {
        self.description = description
        self.matchesFunc = matchesFunc
    }

    public func matches(interaction: Interaction) -> Bool {
        return matchesFunc(interaction)
    }
}

public func matches<Interaction>(matches: Interaction -> Bool) -> Expectation<Interaction> {
    return Expectation(matches: matches)
}


public extension Expectation {
    public init() {
        self.init(description: "_") { _ in true }
    }
}

public func any<Interaction>() -> Expectation<Interaction> {
    return Expectation()
}

public extension Expectation where Interaction: Equatable {
    public typealias Value = Interaction

    public init(value: Value) {
        self.init(description: "\(value)") { $0 == value }
    }
}

public func value<Value: Equatable>(value: Value) -> Expectation<Value> {
    return Expectation(value: value)
}

public protocol ExpectationConvertible {
    typealias InteractionType

    func expectation() -> Expectation<InteractionType>
}

extension Expectation: ExpectationConvertible {
    public func expectation() -> Expectation<Interaction> {
        return self
    }
}

public func tuple<A: ExpectationConvertible>(arg1: A) -> Expectation<(A.InteractionType)> {
    return Expectation(description: "(\(arg1))") { interaction in
        return arg1.expectation().matches(interaction)
    }
}

public func tuple<A: ExpectationConvertible, B: ExpectationConvertible>(arg1: A, _ arg2: B) -> Expectation<(A.InteractionType, B.InteractionType)> {
    return Expectation(description: "(\(arg1), \(arg2))") { interaction in
        return arg1.expectation().matches(interaction.0)
            && arg2.expectation().matches(interaction.1)
    }
}

public func tuple<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible>(arg1: A, _ arg2: B, _ arg3: C) -> Expectation<(A.InteractionType, B.InteractionType, C.InteractionType)> {
    return Expectation(description: "(\(arg1), \(arg2), \(arg3))") { interaction in
        return arg1.expectation().matches(interaction.0)
            && arg2.expectation().matches(interaction.1)
            && arg3.expectation().matches(interaction.2)
    }
}

public func tuple<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible, D: ExpectationConvertible>(arg1: A, _ arg2: B, _ arg3: C, _ arg4: D) -> Expectation<(A.InteractionType, B.InteractionType, C.InteractionType, D.InteractionType)> {
    return Expectation(description: "(\(arg1), \(arg2), \(arg3), \(arg4))") { interaction in
        return arg1.expectation().matches(interaction.0)
            && arg2.expectation().matches(interaction.1)
            && arg3.expectation().matches(interaction.2)
            && arg4.expectation().matches(interaction.3)
    }
}

public func tuple<A: ExpectationConvertible, B: ExpectationConvertible, C: ExpectationConvertible, D: ExpectationConvertible, E: ExpectationConvertible>(arg1: A, _ arg2: B, _ arg3: C, _ arg4: D, _ arg5: E) -> Expectation<(A.InteractionType, B.InteractionType, C.InteractionType, D.InteractionType, E.InteractionType)> {
    return Expectation(description: "(\(arg1), \(arg2), \(arg3), \(arg4), \(arg5))") { interaction in
        return arg1.expectation().matches(interaction.0)
            && arg2.expectation().matches(interaction.1)
            && arg3.expectation().matches(interaction.2)
            && arg4.expectation().matches(interaction.3)
            && arg5.expectation().matches(interaction.4)
    }
}
