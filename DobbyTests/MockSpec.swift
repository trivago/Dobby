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
            it("succeeds if all expectations match an interaction (ordered)") {
                mock.expect(matches((any(), 1)))
                mock.expect(matches((any(), matches { $0 == 2 })))
                mock.record(0, 1)
                mock.record(0, 2)
                mock.verify()
            }

            it("succeeds if all expectations match an interaction (unordered)") {
                mock.expect(matches((any(), 1)))
                mock.expect(matches((any(), matches { $0 == 2 })))
                mock.record(0, 2)
                mock.record(0, 1)
                mock.verify()
            }

            it("succeeds if all expectations match an interaction (multiple equal interactions)") {
                mock.expect(matches((any(), 1)))
                mock.expect(matches((any(), 1)))
                mock.record(0, 1)
                mock.record(0, 1)
                mock.verify()
            }

            it("fails if an expectation is not matched") {
                mock.expect(matches((any(), equals(3))))
                var failureMessageSent = false
                mock.verify { (message, _, _) in
                    failureMessageSent = true
                    expect(message).to(equal("Expectation <(_, 3)> not matched"))
                }
                expect(failureMessageSent).to(beTrue())
            }

            it("fails if an interaction is not matched") {
                mock.record(4, 5)
                var failureMessageSent = false
                mock.verify { (message, _, _) in
                    failureMessageSent = true
                    expect(message).to(equal("Interaction <(4, 5)> not matched"))
                }
                expect(failureMessageSent).to(beTrue())
            }

            it("fails if any expectation does not match an interaction") {
                mock.expect(matches((6, 7)))
                mock.expect(matches((8, matches { $0 == 9 })))
                mock.record(6, 7)
                mock.verify { (message, _, _) in
                    expect(message).to(equal("Expectation <(8, <func>)> not matched"))
                }
            }
        }
    }
}
