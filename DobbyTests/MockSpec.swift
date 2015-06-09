import Quick
import Nimble

import Dobby

class MockSpec: QuickSpec {
    override func spec() {
        var mock: Mock<Int>!

        beforeEach {
            mock = Mock<Int>()
            mock.record(1)
            mock.record(2)
            mock.record(3)
        }

        describe("Recording an interaction") {
            it("should append to the mock's interactions") {
                expect(mock.interactions).to(equal([ 1, 2, 3 ]))
            }
        }

        describe("Verifying interactions") {
            it("should check in-order") {
                expect(mock.contains([])).to(beTrue())
                expect(mock.contains([ 1, 3 ])).to(beTrue())
                expect(mock.contains([ 3, 1 ])).to(beFalse())
            }
        }
    }
}
