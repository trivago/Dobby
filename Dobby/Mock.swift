import XCTest

/// A matcher-based expectation.
private struct Expectation<Interaction> {
    /// The matcher of this expectation.
    private let matcher: Matcher<Interaction>

    /// Whether this expectation is negative.
    private let negative: Bool

    /// Initializes a new expectation with the given matcher and negative flag.
    private init<M: MatcherConvertible where M.ValueType == Interaction>(matcher: M, negative: Bool) {
        self.matcher = matcher.matcher()
        self.negative = negative
    }
}

extension Expectation: Printable {
    private var description: String {
        return matcher.description
    }
}

/// A mock which can verify that all set up expectations have been fulfilled.
public final class Mock<Interaction> {
    /// Whether this mock is strict (or nice).
    private let strict: Bool

    /// Whether the order of expectations matters.
    private let ordered: Bool

    /// All set up and not yet fulfilled expectations.
    private var expectations: [Expectation<Interaction>] = []

    /// Initializes a new mock with the given strict and ordered flags.
    public init(strict: Bool = true, ordered: Bool = true) {
        self.strict = strict
        self.ordered = ordered
    }

    /// Sets up the given matcher as expectation.
    public func expect<M: MatcherConvertible where M.ValueType == Interaction>(matcher: M) {
        expectations.append(Expectation(matcher: matcher, negative: false))
    }

    /// Sets up the given matcher as negative expectation.
    ///
    /// - Note: Negative expectations are restricted to nice mocks.
    public func reject<M: MatcherConvertible where M.ValueType == Interaction>(matcher: M) {
        assert(strict == false, "Setting up a matcher as negative expectation is restricted to nice mocks.")
        expectations.append(Expectation(matcher: matcher, negative: true))
    }

    /// Records the given interaction.
    public func record(interaction: Interaction, file: String = __FILE__, line: UInt = __LINE__) {
        record(interaction, file: file, line: line, fail: XCTFail)
    }

    /// INTERNAL API
    public func record(interaction: Interaction, file: String = __FILE__, line: UInt = __LINE__, fail: (String, file: String, line: UInt) -> ()) {
        for var index = 0; index < expectations.count; index++ {
            let expectation = expectations[index]

            if expectation.matcher.matches(interaction) {
                if expectation.negative == false {
                    expectations.removeAtIndex(index)
                } else {
                    fail("Interaction <\(interaction)> not allowed", file: file, line: line)
                }

                return
            } else if strict && ordered {
                fail("Interaction <\(interaction)> does not match expectation <\(expectation)>", file: file, line: line)
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
            if expectation.negative == false {
                fail("Expectation <\(expectation)> not fulfilled", file: file, line: line)
            }
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
