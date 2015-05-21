import Quick
import Nimble

import Dobby

class MockSpec: QuickSpec {
    override func spec() {
        var mock: Mock<Int>!

        beforeEach {
            mock = Mock<Int>()
            record(mock, 1)
            record(mock, 2)
            record(mock, 3)
        }

        describe("Recording an interaction") {
            it("should append to the mock's interactions") {
                expect(mock.interactions).to(equal([ 1, 2, 3 ]))
            }
        }

        describe("Verifying interactions") {
            it("should check in-order") {
                expect(verify(mock, [])).to(beTrue())
                expect(verify(mock, [ 1, 3 ])).to(beTrue())
                expect(verify(mock, [ 3, 1 ])).to(beFalse())
            }
        }
    }
}
