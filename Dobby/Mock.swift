import XCTest

/// A mock which can verify that all set up expectations are matched with the
/// recorded interactions.
public final class Mock<Interaction> {
    private var expectations: [Expectation<Interaction>] = []
    private var interactions: [Interaction] = []

    /// Initializes a new mock.
    public init() {
        
    }

    /// Sets up the given expectation.
    public func expect<E: ExpectationConvertible where E.ValueType == Interaction>(expectation: E) {
        expectations.append(expectation.expectation())
    }

    /// Records the given interaction.
    public func record(interaction: Interaction) {
        interactions.append(interaction)
    }

    /// Verifies that all set up expectations are matched with the recorded
    /// interactions.
    ///
    /// Verification is performed in order, i.e., the first expectation must
    /// match the first interaction, the second expectation must match the
    /// second interaction, and so on. All expectations must match an
    /// interaction and vice versa.
    public func verify(file: String = __FILE__, line: UInt = __LINE__) {
        verify(file: file, line: line, fail: XCTFail)
    }

    public func verify(file: String = __FILE__, line: UInt = __LINE__, fail: (String, file: String, line: UInt) -> ()) {
        var unmatchedInteractions = interactions
        expectationLoop: for expectation in expectations {
            for var index = 0; index < unmatchedInteractions.count; index++ {
                let interaction = unmatchedInteractions[index]
                if expectation.matches(interaction) {
                    unmatchedInteractions.removeAtIndex(index)
                    continue expectationLoop
                }
            }
            fail("Expectation <\(expectation)> not matched", file: file, line: line)
        }
        for interaction in unmatchedInteractions {
            fail("Interaction <\(interaction)> not matched", file: file, line: line)
        }
    }
}
