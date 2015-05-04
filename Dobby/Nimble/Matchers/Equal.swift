import Nimble

func equal<Interaction: Equatable>(interactions: Interaction...) -> NonNilMatcherFunc<Mock<Interaction>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(interactions)>"
        if let actual = actualExpression.evaluate() {
            return Dobby.equals(actual, interactions)
        }
        return false
    }
}
