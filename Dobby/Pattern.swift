import XCTest

/// A value type-erased expectation.
fileprivate struct Expectation: CustomStringConvertible {
    fileprivate let description: String

    /// The matching closure of this expectation.
    ///
    /// Given the index of a recorded interaction, the closure is supposed to
    /// check whether the corresponding value fulfills this expectation.
    fileprivate let matches: (Int) -> Bool

    /// The recorder that is expected (not) to record an interaction with a
    /// corresponding matching value.
    fileprivate let recorder: InteractionRecording

    /// Whether this expectation is negative.
    fileprivate let negative: Bool

    /// The file in which this expectation was set up.
    fileprivate let file: StaticString

    /// The line at which this expectation was set up.
    fileprivate let line: UInt

    /// Creates a new value type-erased expectation with the given description,
    /// matching closure, recorder, and negative flag.
    fileprivate init(description: String, matches: @escaping (Int) -> Bool, recorder: InteractionRecording, negative: Bool, file: StaticString, line: UInt) {
        self.description = description
        self.matches = matches

        self.recorder = recorder
        self.negative = negative

        self.file = file
        self.line = line
    }

    /// Creates a new value type-erased expectation with the given matcher,
    /// recorder, and negative flag using the matcher's textual representation
    /// as description.
    fileprivate init<Matcher: MatcherConvertible, Recorder: ValueRecording>(matcher: Matcher, recorder: Recorder, negative: Bool, file: StaticString, line: UInt) where Matcher.ValueType == Recorder.Value {
        let actualMatcher = matcher.matcher()

        // The matching closure captures the value type of the recorder.
        let matches = { (index: Int) -> Bool in
            let actualValue = recorder.valueForInteraction(at: index)
            return actualMatcher.matches(actualValue)
        }

        self.init(description: actualMatcher.description, matches: matches, recorder: recorder, negative: negative, file: file, line: line)
    }
}

/// An iterator over a given set of interaction recorders, producing their
/// interactions in chronological order.
fileprivate struct InteractionRecordingIterator: IteratorProtocol {
    fileprivate struct Element: CustomStringConvertible {
        fileprivate let recorder: InteractionRecording

        fileprivate var index: Int

        fileprivate var interaction: Interaction {
            return recorder.interactions[AnyIndex(index)]
        }

        fileprivate var description: String {
            return interaction.description
        }

        fileprivate var timestamp: Timestamp {
            return interaction.timestamp
        }

        fileprivate var file: StaticString {
            return interaction.file
        }

        fileprivate var line: UInt {
            return interaction.line
        }
    }

    private var elements: [Element]

    private mutating func heapify(at index: Int) {
        var parentIndex = index

        while parentIndex < elements.count {
            let leftChildIndex = 2 * parentIndex + 1
            let rightChildIndex = 2 * parentIndex + 2

            var smallestIndex = parentIndex

            if leftChildIndex < elements.count && elements[leftChildIndex].timestamp < elements[smallestIndex].timestamp {
                smallestIndex = leftChildIndex
            }

            if rightChildIndex < elements.count && elements[rightChildIndex].timestamp < elements[smallestIndex].timestamp {
                smallestIndex = rightChildIndex
            }

            if smallestIndex == parentIndex {
                break
            }

            let parent = elements[parentIndex]
            elements[parentIndex] = elements[smallestIndex]
            elements[smallestIndex] = parent
            
            parentIndex = smallestIndex
        }
    }

    fileprivate init(recorders: Set<AnyInteractionRecording>) {
        elements = recorders.filter({ recorder in
            return !recorder.interactions.isEmpty
        }).map({ recorder in
            return Element(recorder: recorder, index: 0)
        })

        for index in stride(from: (elements.count / 2 - 1), through: 0, by: -1) {
            heapify(at: index)
        }
    }

    fileprivate mutating func next() -> Element? {
        guard let element = elements.first else {
            return nil
        }

        if element.index + 1 == element.recorder.interactions.count {
            if elements.count == 1 {
                elements.removeLast()
            } else {
                elements[0] = elements.removeLast()
            }
        } else {
            elements[0].index += 1
        }

        heapify(at: 0)

        return element
    }
}

/// A thread-safe pattern that can verify set up expectations with multiple
/// interaction recorders.
public final class Pattern {
    /// Whether this pattern is strict (or nice).
    private let strict: Bool

    /// Whether the order of expectations matters.
    private let ordered: Bool

    /// All set up expectations.
    private var expectations: [Expectation] = []
    private let expectationsQueue = DispatchQueue(label: "com.trivago.dobby.pattern-expectationsQueue", attributes: .concurrent)

    /// Creates a new pattern with the given strict and ordered flags.
    public init(strict: Bool = true, ordered: Bool = true) {
        self.strict = strict
        self.ordered = ordered
    }

    /// Creates a new pattern with the given nice and ordered flags.
    public convenience init(nice: Bool, ordered: Bool = true) {
        self.init(strict: nice == false, ordered: ordered)
    }

    /// Sets up the given matcher as expectation for the given recorder.
    public func expect<Matcher: MatcherConvertible, Recorder: ValueRecording>(_ matcher: Matcher, in recorder: Recorder, file: StaticString = #file, line: UInt = #line) where Matcher.ValueType == Recorder.Value {
        let expectation = Expectation(matcher: matcher, recorder: recorder, negative: false, file: file, line: line)

        expectationsQueue.sync(flags: .barrier, execute: {
            expectations.append(expectation)
        })
    }

    /// Sets up the given matcher as negative expectation for the given
    /// recorder, meaning any matching value will be rejected.
    ///
    /// - Note: Negative expectations are restricted to nice patterns.
    public func reject<Matcher: MatcherConvertible, Recorder: ValueRecording>(_ matcher: Matcher, in recorder: Recorder, file: StaticString = #file, line: UInt = #line) where Matcher.ValueType == Recorder.Value {
        precondition(strict == false, "Only nice patterns may have negative expectations.")

        let expectation = Expectation(matcher: matcher, recorder: recorder, negative: true, file: file, line: line)

        expectationsQueue.sync(flags: .barrier, execute: {
            expectations.append(expectation)
        })
    }

    /// Verifies that all set up expectations are fulfilled by continuously
    /// checking at each poll interval until the timeout is reached.
    public func verify(poll: TimeInterval = 0.01, timeout: TimeInterval = 0) {
        verify(poll: poll, timeout: timeout, fail: XCTFail)
    }

    internal func verify(poll: TimeInterval, timeout: TimeInterval, fail: (String, StaticString, UInt) -> ()) {
        var failures: [(String, StaticString, UInt)]

        // Set the initial limit date to now.
        var limitDate = Date()

        // Set the timeout date using the specified timeout.
        let timeoutDate = Date(timeInterval: timeout, since: limitDate)

        // Repetitively attempt to verify that all set up expectations are
        // fulfilled until the timeout is reached.
        repeat {
            // Discard any previous failures.
            failures = []

            // Attempt to verify that all set up expectations are fulfilled.
            verify(fail: { message, file, line in
                failures.append((message, file, line))
            })

            // Finish if verification was successful.
            if failures.isEmpty {
                return
            }

            // Add the poll time interval to the limit date.
            limitDate = Date(timeInterval: poll, since: limitDate)

            // Run the current loop until the limit date, at most until the
            // timeout date. Nimble uses a more advanced technique based on
            // dispatch sources, we should take a look.
            let currentLoop: RunLoop = .current
            currentLoop.run(until: min(limitDate, timeoutDate))
        } while Date() < timeoutDate

        for (message, file, line) in failures {
            fail(message, file, line)
        }
    }

    internal func verify(fail: (String, StaticString, UInt) -> ()) {
        var expectations = expectationsQueue.sync(execute: {
            return self.expectations
        })

        let recorders = Set(expectations.map({ expectation in
            return AnyInteractionRecording(expectation.recorder)
        }))

        let iterator = InteractionRecordingIterator(recorders: recorders)

        replay: for interaction in IteratorSequence(iterator) {
            for (index, expectation) in expectations.enumerated() {
                if expectation.recorder.objectIdentifier == interaction.recorder.objectIdentifier && expectation.matches(interaction.index) {
                    if expectation.negative == false {
                        expectations.remove(at: index)
                    } else {
                        fail("Interaction <\(interaction)> not allowed", interaction.file, interaction.line)
                    }

                    continue replay
                } else if ordered {
                    if strict {
                        fail("Interaction <\(interaction)> does not match expectation <\(expectation)>", interaction.file, interaction.line)
                    }

                    if expectation.negative == false {
                        continue replay
                    }
                }
            }

            if strict {
                fail("Interaction <\(interaction)> not expected", interaction.file, interaction.line)
            }
        }

        for expectation in expectations {
            if expectation.negative == false {
                fail("Expectation <\(expectation)> not fulfilled", expectation.file, expectation.line)
            }
        }
    }
}
