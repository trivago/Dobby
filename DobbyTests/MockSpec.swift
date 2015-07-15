import Quick
import Nimble

@testable import Dobby

class MockSpec: QuickSpec {
    override func spec() {
        var mock: Mock<(Int, Int)>!

        beforeEach {
            mock = Mock()
        }

        context("Verification") {
            it("succeeds if all expectations match an interaction") {
                mock.expect(tuple(any(), 1))
                mock.expect(tuple(any(), matches { $0 == 2 }))
                mock.record((0, 1))
                mock.record((0, 2))
                mock.verify()
            }

            it("fails if an expectation is not matched") {
                mock.expect(tuple(any(), value(3)))
                mock.verify { (message, _, _) in
                    expect(message).to(equal("Expectation <(_, 3)> not matched"))
                }
            }

            it("fails if an interaction is not matched") {
                mock.record((4, 5))
                mock.verify { (message, _, _) in
                    expect(message).to(equal("Interaction <(4, 5)> not matched"))
                }
            }

            it("fails if any expectation does not match an interaction") {
                mock.expect(tuple(6, 7))
                mock.expect(tuple(8, matches { $0 == 9 }))
                mock.record((6, 7))
                mock.record((8, 10))
                mock.verify { (message, _, _) in
                    expect(message).to(equal("Expectation <(8, <func>)> does not match interaction <(8, 10)>"))
                }
            }
        }
    }
}
