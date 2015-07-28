extension Bool: ExpectationConvertible {
    public func expectation() -> Expectation<Bool> {
        return Expectation(description: "\(self)", matches: { actualValue in self == actualValue })
    }
}

extension Int: ExpectationConvertible {
    public func expectation() -> Expectation<Int> {
        return Expectation(description: "\(self)", matches: { actualValue in self == actualValue })
    }
}

extension Float: ExpectationConvertible {
    public func expectation() -> Expectation<Float> {
        return Expectation(description: "\(self)", matches: { actualValue in self == actualValue })
    }
}

extension Double: ExpectationConvertible {
    public func expectation() -> Expectation<Double> {
        return Expectation(description: "\(self)", matches: { actualValue in self == actualValue })
    }
}

extension String: ExpectationConvertible {
    public func expectation() -> Expectation<String> {
        return Expectation(description: "\(self)", matches: { actualValue in self == actualValue })
    }
}
