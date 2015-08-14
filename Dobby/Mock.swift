import XCTest

/// A mock which can verify that all set up expectations are matched with the
/// recorded interactions.
public final class Mock<Interaction> {
    private var expectations: [Expectation<Interaction>] = []

    /// Initializes a new mock.
    public init() {
        
    }

    /// Sets up the given expectation.
    public func expect<E: ExpectationConvertible where E.ValueType == Interaction>(expectation: E) {
        expectations.append(expectation.expectation())
    }

    /// Records the given interaction.
    public func record(interaction: Interaction, file: String = __FILE__, line: UInt = __LINE__) {
        record(interaction, file: file, line: line, fail: XCTFail)
    }

    /// INTERNAL API
    public func record(interaction: Interaction, file: String = __FILE__, line: UInt = __LINE__, fail: (String, file: String, line: UInt) -> ()) {
        if let expectation = expectations.first {
            if expectation.matches(interaction) {
                expectations.removeAtIndex(0)
            } else {
                fail("Interaction <\(interaction)> does not match expectation <\(expectation)>", file: file, line: line)
            }
        } else {
            fail("Interaction <\(interaction)> not expected", file: file, line: line)
        }
    }

    /// Verifies that all set up expectations have been matched.
    public func verify(file: String = __FILE__, line: UInt = __LINE__) {
        verify(file: file, line: line, fail: XCTFail)
    }

    /// INTERNAL API
    public func verify(file: String = __FILE__, line: UInt = __LINE__, fail: (String, file: String, line: UInt) -> ()) {
        for expectation in expectations {
            fail("Expectation <\(expectation)> not matched", file: file, line: line)
        }
    }
}
