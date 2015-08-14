import Quick
import Nimble

import Dobby

class MockSpec: QuickSpec {
    override func spec() {
        var mock: Mock<(Int, Int)>!

        beforeEach {
            mock = Mock()
        }

        describe("Verification") {
            it("succeeds if all expectations match an interaction") {
                mock.expect(matches((any(), 1)))
                mock.expect(matches((any(), matches { $0 == 2 })))
                mock.record((0, 1))
                mock.record((0, 2))
                mock.verify()
            }

            it("fails if an expectation is not matched") {
                var failureMessageSent = false
                mock.expect(matches((any(), equals(3))))
                mock.verify { (message, _, _) in
                    failureMessageSent = true
                    expect(message).to(equal("Expectation <(_, 3)> not matched"))
                }
                expect(failureMessageSent).to(beTrue())
            }

            it("fails if an interaction is not matched") {
                var failureMessageSent = false
                mock.record((4, 5)) { (message, _, _) in
                    failureMessageSent = true
                    expect(message).to(equal("Received unexpected Interaction <(4, 5)>"))
                }
                expect(failureMessageSent).to(beTrue())
            }

        }
    }
}
