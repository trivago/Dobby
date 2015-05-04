import Quick
import Nimble

import Dobby

class EqualSpec: QuickSpec {
    override func spec() {
        var mock: Mock<Int>!

        beforeEach {
            mock = Mock<Int>()
            record(mock, 1)
            record(mock, 2)
            record(mock, 3)
        }

        describe("Verifying interactions for equality") {
            it("should check in-order") {
                failsWithErrorMessage("expected interactions to equal <[]>, got <[1, 2, 3]>") {
                    verify(mock).to(equal())
                }

                verify(mock).to(equal(1, 2, 3))

                failsWithErrorMessage("expected interactions to equal <[3, 2, 1]>, got <[1, 2, 3]>") {
                    verify(mock).to(equal(3, 2, 1))
                }
            }
        }
    }
}

