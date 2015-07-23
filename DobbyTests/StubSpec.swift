import Quick
import Nimble

import Dobby

class StubSpec: QuickSpec {
    override func spec() {
        var stub: Stub<(Int, Int), Int>!

        beforeEach {
            stub = Stub()
        }

        context("Invocation") {
            it("returns the correct value") {
                stub.on(matches((4, 3)), returnValue: 9)
                stub.on(matches((any(), any()))) { $0.0 + $0.1 }
                expect(try! stub.invoke((4, 3))).to(equal(9))
                expect(try! stub.invoke((4, 4))).to(equal(8))
            }

            it("returns the correct value after disposal") {
                let disposable1 = stub.on(matches((4, 3)), returnValue: 9)
                let disposable2 = stub.on(matches((any(), any()))) { $0.0 + $0.1 }

                disposable1.dispose()

                expect(disposable1.disposed).to(beTrue())
                expect(disposable2.disposed).to(beFalse())

                expect(try! stub.invoke((4, 3))).to(equal(7))
            }

            it("throws an exception if an interaction is unexpected") {
                do {
                    try stub.invoke((5, 6))
                } catch StubError<(Int, Int)>.UnexpectedInteraction(let interaction) {
                    expect(interaction.0).to(equal(5))
                    expect(interaction.1).to(equal(6))
                } catch {
                    fail("Unexpected exception: \(error)")
                }
            }
        }
    }
}
