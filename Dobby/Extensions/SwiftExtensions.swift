extension Bool: ExpectationConvertible {
    public func expectation() -> Expectation<Bool> {
        return equals(self)
    }
}

extension Int: ExpectationConvertible {
    public func expectation() -> Expectation<Int> {
        return equals(self)
    }
}

extension Float: ExpectationConvertible {
    public func expectation() -> Expectation<Float> {
        return equals(self)
    }
}

extension Double: ExpectationConvertible {
    public func expectation() -> Expectation<Double> {
        return equals(self)
    }
}

extension String: ExpectationConvertible {
    public func expectation() -> Expectation<String> {
        return equals(self)
    }
}
