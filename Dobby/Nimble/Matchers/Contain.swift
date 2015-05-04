import Nimble

public func contain<Interaction: Equatable>(interactions: Interaction...) -> NonNilMatcherFunc<Mock<Interaction>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "contain <\(interactions)>"
        if let actual = actualExpression.evaluate() {
            return Dobby.contains(actual, interactions)
        }
        return false
    }
}
