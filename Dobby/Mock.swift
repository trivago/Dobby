import XCTest

/// A mock which can verify that all set up expectations are matched with the
/// recorded interactions.
public final class Mock<Interaction> {
    private let ordered: Bool

    private var expectations: [Expectation<Interaction>] = []

    /// Initializes a new mock.
    public init(ordered: Bool = true) {
        self.ordered = ordered
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
        for var index = 0; index < expectations.count; index++ {
            if expectations[index].matches(interaction) {
                expectations.removeAtIndex(index)
                return
            } else if ordered {
                fail("Interaction <\(interaction)> does not match expectation <\(expectations[index])>", file: file, line: line)
                return
            }
        }

        fail("Interaction <\(interaction)> not expected", file: file, line: line)
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
