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

        describe("Verifying interactions for containment") {
            it("should check in-order") {
                verify(mock).to(contain())
                verify(mock).to(contain(1, 3))

                failsWithErrorMessage("expected interactions to contain <[3, 1]>, got <[1, 2, 3]>") {
                    verify(mock).to(contain(3, 1))
                }
            }
        }
    }
}
