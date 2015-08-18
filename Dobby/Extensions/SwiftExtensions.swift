extension Bool: MatcherConvertible {
    public func matcher() -> Matcher<Bool> {
        return equals(self)
    }
}

extension Int: MatcherConvertible {
    public func matcher() -> Matcher<Int> {
        return equals(self)
    }
}

extension Float: MatcherConvertible {
    public func matcher() -> Matcher<Float> {
        return equals(self)
    }
}

extension Double: MatcherConvertible {
    public func matcher() -> Matcher<Double> {
        return equals(self)
    }
}

extension String: MatcherConvertible {
    public func matcher() -> Matcher<String> {
        return equals(self)
    }
}
