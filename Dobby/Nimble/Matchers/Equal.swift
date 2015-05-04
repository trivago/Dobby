import Nimble

public func equal<Interaction: Equatable>(interactions: Interaction...) -> NonNilMatcherFunc<Mock<Interaction>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.expected = "expected interactions"
        failureMessage.postfixMessage = "equal <\(interactions)>"
        if let actual = actualExpression.evaluate() {
            failureMessage.actualValue = "<\(actual.interactions)>"
            return Dobby.equals(actual, interactions)
        }
        return false
    }
}
