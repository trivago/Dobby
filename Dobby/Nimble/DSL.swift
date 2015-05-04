import Nimble

func verify<Interaction: Equatable>(mock: Mock<Interaction>, file: String = __FILE__, line: UInt = __LINE__) -> Expectation<Mock<Interaction>> {
    return expect(mock, file: file, line: line)
}
