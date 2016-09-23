import XCTest

/// A matcher-based expectation.
fileprivate struct Expectation<Interaction> {
    /// The matcher of this expectation.
    fileprivate let matcher: Matcher<Interaction>

    /// Whether this expectation is negative.
    fileprivate let negative: Bool

    /// Initializes a new expectation with the given matcher and negative flag.
    fileprivate init<M: MatcherConvertible>(matcher: M, negative: Bool) where M.ValueType == Interaction {
        self.matcher = matcher.matcher()
        self.negative = negative
    }
}

extension Expectation: CustomStringConvertible {
    fileprivate var description: String {
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

    /// Initializes a new mock with the given nice and ordered flags.
    public convenience init(nice: Bool, ordered: Bool = true) {
        self.init(strict: nice == false, ordered: ordered)
    }

    /// Sets up the given matcher as expectation.
    public func expect<M: MatcherConvertible>(_ matcher: M) where M.ValueType == Interaction {
        let expectation = Expectation(matcher: matcher, negative: false)
        expectations.append(expectation)
    }

    /// Sets up the given matcher as negative expectation.
    ///
    /// - Note: Negative expectations are restricted to nice mocks.
    public func reject<M: MatcherConvertible>(_ matcher: M) where M.ValueType == Interaction {
        assert(strict == false, "Setting up a matcher as negative expectation is restricted to nice mocks.")

        let expectation = Expectation(matcher: matcher, negative: true)
        expectations.append(expectation)
    }

    /// Records the given interaction.
    public func record(_ interaction: Interaction, file: StaticString = #file, line: UInt = #line) {
        record(interaction, file: file, line: line, fail: XCTFail)
    }

    internal func record(_ interaction: Interaction, file: StaticString = #file, line: UInt = #line, fail: (String, StaticString, UInt) -> ()) {
        for (index, expectation) in expectations.enumerated() {
            if expectation.matcher.matches(interaction) {
                if expectation.negative == false {
                    expectations.remove(at: index)
                } else {
                    fail("Interaction <\(interaction)> not allowed", file, line)
                }

                return
            } else if ordered {
                if strict {
                    fail("Interaction <\(interaction)> does not match expectation <\(expectation)>", file, line)
                }

                return
            }
        }

        if strict {
            fail("Interaction <\(interaction)> not expected", file, line)
        }
    }

    /// Verifies that all set up expectations have been fulfilled.
    public func verify(file: StaticString = #file, line: UInt = #line) {
        verify(file: file, line: line, fail: XCTFail)
    }

    internal func verify(file: StaticString = #file, line: UInt = #line, fail: (String, StaticString, UInt) -> ()) {
        for expectation in expectations {
            if expectation.negative == false {
                fail("Expectation <\(expectation)> not fulfilled", file, line)
            }
        }
    }

    /// Verifies that all set up expectations are fulfilled within the given
    /// delay.
    public func verifyWithDelay(_ delay: TimeInterval = 1.0, file: StaticString = #file, line: UInt = #line) {
        verifyWithDelay(delay, file: file, line: line, fail: XCTFail)
    }

    internal func verifyWithDelay(_ delay: TimeInterval, file: StaticString = #file, line: UInt = #line, fail: (String, StaticString, UInt) -> ()) {
        var rest = delay
        var step = 0.01

        while rest > 0 && expectations.count > 0 {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: step))
            rest -= step; step *= 2
        }

        verify(file: file, line: line, fail: fail)
    }
}
