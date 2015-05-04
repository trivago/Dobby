import Quick
import Nimble

import Dobby

class ContainSpec: QuickSpec {
    override func spec() {
        var mock: Mock<Int>!

        beforeEach {
            mock = Mock<Int>()
            record(mock, 1)
            record(mock, 2)
            record(mock, 3)
        }

        describe("Verifying interactions") {
            describe("for equality") {
                it("should check in-order") {
                    failsWithErrorMessage("expected to equal <[]>, got <Dobby.Mock<Swift.Int>>") {
                        verify(mock).to(equal())
                    }

                    verify(mock).to(equal(1, 2, 3))

                    failsWithErrorMessage("expected to equal <[3, 2, 1]>, got <Dobby.Mock<Swift.Int>>") {
                        verify(mock).to(equal(3, 2, 1))
                    }
                }
            }

            describe("for containment") {
                it("should check in-order") {
                    verify(mock).to(contain())
                    verify(mock).to(contain(1, 3))

                    failsWithErrorMessage("expected to contain <[3, 1]>, got <Dobby.Mock<Swift.Int>>") {
                        verify(mock).to(contain(3, 1))
                    }
                }
            }
        }
    }
}
