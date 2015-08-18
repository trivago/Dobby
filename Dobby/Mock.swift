import XCTest

/// A mock which can verify that all set up expectations have been fulfilled.
public final class Mock<Interaction> {
    private let strict: Bool
    private let ordered: Bool

    private var expectations: [Matcher<Interaction>] = []

    /// Initializes a new mock.
    public init(strict: Bool = true, ordered: Bool = true) {
        self.strict = strict
        self.ordered = ordered
    }

    /// Sets up the given matcher as expectation.
    public func expect<M: MatcherConvertible where M.ValueType == Interaction>(matcher: M) {
        expectations.append(matcher.matcher())
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
            } else if strict && ordered {
                fail("Interaction <\(interaction)> does not match expectation <\(expectations[index])>", file: file, line: line)
                return
            }
        }

        if strict {
            fail("Interaction <\(interaction)> not expected", file: file, line: line)
        }
    }

    /// Verifies that all set up expectations have been fulfilled.
    public func verify(file: String = __FILE__, line: UInt = __LINE__) {
        verify(file: file, line: line, fail: XCTFail)
    }

    /// INTERNAL API
    public func verify(file: String = __FILE__, line: UInt = __LINE__, fail: (String, file: String, line: UInt) -> ()) {
        for expectation in expectations {
            fail("Expectation <\(expectation)> not fulfilled", file: file, line: line)
        }
    }

    /// Verifies that all set up expectations are fulfilled within the given
    /// delay.
    public func verifyWithDelay(_ delay: NSTimeInterval = 1.0, file: String = __FILE__, line: UInt = __LINE__) {
        verifyWithDelay(delay, file: file, line: line, fail: XCTFail)
    }

    /// INTERNAL API
    public func verifyWithDelay(var delay: NSTimeInterval, file: String = __FILE__, line: UInt = __LINE__, fail: (String, file: String, line: UInt) -> ()) {
        var step = 0.01

        while delay > 0 && expectations.count > 0 {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: step))
            delay -= step; step *= 2
        }

        verify(file: file, line: line, fail: fail)
    }
}
