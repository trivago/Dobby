import Quick
import Nimble

import Dobby

class MockSpec: QuickSpec {
    override func spec() {
        var mock: Mock<(Int, Int)>!

        describe("Recording") {
            context("when the mock is strict and the order of expectations matters") {
                beforeEach {
                    mock = Mock(strict: true, ordered: true)
                }

                it("succeeds if the given interaction matches the next expectation") {
                    mock.expect(matches((6, 7)))
                    mock.expect(matches((8, 9)))
                    mock.record((6, 7))
                    mock.record((8, 9))
                }

                it("fails if the given interaction does not match the next expectation") {
                    var failureMessage: String?

                    mock.expect(matches((2, 3)))
                    mock.expect(matches((4, 5)))
                    mock.record((4, 5)) { (message, _, _) in
                        failureMessage = message
                    }

                    expect(failureMessage).to(equal("Interaction <(4, 5)> does not match expectation <(2, 3)>"))
                }

                it("fails if the given interaction is not expected") {
                    var failureMessage: String?

                    mock.record((4, 5)) { (message, _, _) in
                        failureMessage = message
                    }

                    expect(failureMessage).to(equal("Interaction <(4, 5)> not expected"))
                }
            }

            context("when the mock is strict and the order of expectations doesn't matter") {
                beforeEach {
                    mock = Mock(strict: true, ordered: false)
                }

                it("succeeds if the given interaction matches any expectation") {
                    mock.expect(matches((6, 7)))
                    mock.expect(matches((8, 9)))
                    mock.record((8, 9))
                    mock.record((6, 7))
                }

                it("fails if the given interaction does not match any expectation") {
                    var failureMessage: String?

                    mock.expect(matches((2, 3)))
                    mock.record((4, 5)) { (message, _, _) in
                        failureMessage = message
                    }

                    expect(failureMessage).to(equal("Interaction <(4, 5)> not expected"))
                }

                it("fails if the given interaction is not expected") {
                    var failureMessage: String?

                    mock.record((4, 5)) { (message, _, _) in
                        failureMessage = message
                    }

                    expect(failureMessage).to(equal("Interaction <(4, 5)> not expected"))
                }
            }

            context("when the mock is nice") {
                beforeEach {
                    mock = Mock(strict: false)
                }

                it("succeeds if the given interaction doesn't match any expectation") {
                    mock.expect(matches((6, 7)))
                    mock.record((8, 9))
                }

                it("succeeds if the given interaction is not expected") {
                    mock.record((8, 9))
                }
            }
        }

        describe("Verification") {
            beforeEach {
                mock = Mock()
            }

            it("succeeds if all interactions match an expectation") {
                mock.expect(matches((any(), 1)))
                mock.expect(matches((any(), matches { $0 == 2 })))
                mock.record((0, 1))
                mock.record((0, 2))
                mock.verify()
            }

            it("fails if an expectation is not matched") {
                var failureMessage: String?

                mock.expect(matches((any(), equals(3))))
                mock.verify { (message, _, _) in
                    failureMessage = message
                }

                expect(failureMessage).to(equal("Expectation <(_, 3)> not matched"))

        describe("Verification with delay") {
            beforeEach {
                mock = Mock()
            }

            it("succeeds if all expectations are matched within the given delay") {
                mock.expect(matches((any(), 1)))
                mock.expect(matches((any(), matches { $0 == 2 })))
                mock.record((0, 1))

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    mock.record((0, 2))
                }

                mock.verifyWithDelay(0.5)
            }

            it("fails if any expectation is matched within the given delay") {
                var failureMessage: String?

                mock.expect(matches((any(), 1)))
                mock.expect(matches((any(), equals(2))))
                mock.record((0, 1))
                mock.verifyWithDelay(0.25) { (message, _, _) in
                    failureMessage = message
                }

                expect(failureMessage).to(equal("Expectation <(_, 2)> not matched"))
            }
        }
    }
}
