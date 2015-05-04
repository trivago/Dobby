import Nimble

public func contain<Interaction: Equatable>(interactions: Interaction...) -> NonNilMatcherFunc<Mock<Interaction>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.expected = "expected interactions"
        failureMessage.postfixMessage = "contain <\(interactions)>"
        if let actual = actualExpression.evaluate() {
            failureMessage.actualValue = "<\(actual.interactions)>"
            return Dobby.contains(actual, interactions)
        }
        return false
    }
}
