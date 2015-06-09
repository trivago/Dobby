import Quick
import Nimble

import Dobby

class DSLSpec: QuickSpec {
    override func spec() {
        var mock: Mock<Int>!

        beforeEach {
            mock = Mock<Int>()
            mock.record(1)
            mock.record(2)
            mock.record(3)
        }

        describe("Verification") {
            it("should be performed on the mock's interactions") {
                verify(mock).to(equal([ 1, 2, 3 ]))
            }
        }
    }
}
