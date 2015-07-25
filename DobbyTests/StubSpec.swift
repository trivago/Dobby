import Quick
import Nimble

import Dobby

class StubSpec: QuickSpec {
    override func spec() {
        var stub: Stub<(Int, Int), Int>!

        beforeEach {
            stub = Stub()
        }

        describe("Invocation") {
            it("returns the correct value") {
                stub.on(matches((4, 3)), returnValue: 9)
                stub.on(matches((any(), any()))) { $0.0 + $0.1 }
                expect(stub.invoke(4, 3)).to(equal(9))
                expect(stub.invoke(4, 4)).to(equal(8))
            }

            it("returns the correct value after disposal") {
                let disposable1 = stub.on(matches((4, 3)), returnValue: 9)
                let disposable2 = stub.on(matches((any(), any()))) { $0.0 + $0.1 }

                disposable1.dispose()

                expect(disposable1.disposed).to(beTrue())
                expect(disposable2.disposed).to(beFalse())

                expect(stub.invoke(4, 3)).to(equal(7))
            }

            it("returns nil if an interaction is unexpected") {
                expect(stub.invoke(5, 6)).to(beNil())
            }
        }
    }
}
