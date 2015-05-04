import Nimble

public func verify<Interaction: Equatable>(mock: Mock<Interaction>, file: String = __FILE__, line: UInt = __LINE__) -> Expectation<[Interaction]> {
    return expect(mock.interactions, file: file, line: line)
}
