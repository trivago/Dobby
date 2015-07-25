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
        for var index = 0; index < max(expectations.count, interactions.count); index++ {
            if index >= interactions.count {
                fail("Expectation <\(expectations[index])> not matched", file: file, line: line)
            } else if index >= expectations.count {
                fail("Interaction <\(interactions[index])> not matched", file: file, line: line)
            } else if !expectations[index].matches(interactions[index]) {
                fail("Expectation <\(expectations[index])> does not match interaction <\(interactions[index])>", file: file, line: line)
            }
        }
    }
}
