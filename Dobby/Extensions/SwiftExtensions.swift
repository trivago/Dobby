extension Bool: ArgumentConvertible {
    public func argument() -> Argument<Bool> {
        return Argument.Value(self)
    }
}

extension Int: ArgumentConvertible {
    public func argument() -> Argument<Int> {
        return Argument.Value(self)
    }
}

extension Float: ArgumentConvertible {
    public func argument() -> Argument<Float> {
        return Argument.Value(self)
    }
}

extension Double: ArgumentConvertible {
    public func argument() -> Argument<Double> {
        return Argument.Value(self)
    }
}

extension String: ArgumentConvertible {
    public func argument() -> Argument<String> {
        return Argument.Value(self)
    }
}
