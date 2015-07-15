extension Bool: ExpectationConvertible {
    public func expectation() -> Expectation<Bool> {
        return Expectation(value: self)
    }
}

extension Int: ExpectationConvertible {
    public func expectation() -> Expectation<Int> {
        return Expectation(value: self)
    }
}

extension Float: ExpectationConvertible {
    public func expectation() -> Expectation<Float> {
        return Expectation(value: self)
    }
}

extension Double: ExpectationConvertible {
    public func expectation() -> Expectation<Double> {
        return Expectation(value: self)
    }
}

extension String: ExpectationConvertible {
    public func expectation() -> Expectation<String> {
        return Expectation(value: self)
    }
}
