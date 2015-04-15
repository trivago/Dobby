import Box

extension Bool: ArgumentConvertible {
    public func argument() -> Argument<Bool> {
        return Argument.Value(Box(self))
    }
}

extension Int: ArgumentConvertible {
    public func argument() -> Argument<Int> {
        return Argument.Value(Box(self))
    }
}

extension Float: ArgumentConvertible {
    public func argument() -> Argument<Float> {
        return Argument.Value(Box(self))
    }
}

extension Double: ArgumentConvertible {
    public func argument() -> Argument<Double> {
        return Argument.Value(Box(self))
    }
}

extension String: ArgumentConvertible {
    public func argument() -> Argument<String> {
        return Argument.Value(Box(self))
    }
}
