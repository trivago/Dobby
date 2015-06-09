import Quick
import Nimble

import Dobby

class StubSpec: QuickSpec {
    override func spec() {
        var stub: Stub<Int, Int>!

        beforeEach {
            stub = Stub<Int, Int>()
            stub.behave(1, 2)
            stub.behave(2, 4)
        }

        describe("Stubbing") {
            it("should append to the stub's behavior") {
                expect(stub.behavior[0].interaction).to(equal(1))
                expect(stub.behavior[0].returnValue).to(equal(2))
                expect(stub.behavior[1].interaction).to(equal(2))
                expect(stub.behavior[1].returnValue).to(equal(4))
            }
        }

        describe("Invoking a stub") {
            it("should return the first matching interaction's return value") {
                expect(stub.invoke(0)).to(beNil())
                expect(stub.invoke(1)).to(equal(2))
                expect(stub.invoke(2)).to(equal(4))
            }
        }
    }
}
