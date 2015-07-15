import XCTest

public final class Mock<Interaction> {
    private var expectations: [Expectation<Interaction>] = []
    private var interactions: [Interaction] = []

    public init() {
        
    }

    public func expect<E: ExpectationConvertible where E.InteractionType == Interaction>(expectation: E) {
        expectations.append(expectation.expectation())
    }

    public func record(interaction: Interaction) {
        interactions.append(interaction)
    }

    public func verify(file file: String = __FILE__, line: UInt = __LINE__) {
        verify(file: file, line: line, fail: XCTFail)
    }

    internal func verify(file file: String = __FILE__, line: UInt = __LINE__, fail: (String, file: String, line: UInt) -> ()) {
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
