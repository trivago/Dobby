import Quick
import Nimble

import Dobby

class BehaviorSpec: QuickSpec {
    override func spec() {
        var behavior: Behavior<(Int, Int), Int>!

        beforeEach {
            behavior = Behavior()
        }

        describe("Invocation") {
            it("returns the correct value") {
                behavior.on(matches((4, 3)), return: 9)
                behavior.on(matches((any(), any()))) { $0.0 + $0.1 }
                expect(try! behavior.invoke((4, 3))).to(equal(9))
                expect(try! behavior.invoke((4, 4))).to(equal(8))
            }

            it("returns the correct value after disposal") {
                let disposable1 = behavior.on(matches((4, 3)), return: 9)
                let disposable2 = behavior.on(matches((any(), any()))) { $0.0 + $0.1 }

                disposable1.dispose()

                expect(disposable1.disposed).to(beTrue())
                expect(disposable2.disposed).to(beFalse())

                expect(try! behavior.invoke((4, 3))).to(equal(7))
            }

            it("throws an exception if an interaction is unexpected") {
                do {
                    try behavior.invoke((5, 6))
                } catch BehaviorError<(Int, Int), Int>.unexpectedInteraction(let interaction) {
                    expect(interaction.0).to(equal(5))
                    expect(interaction.1).to(equal(6))
                    return;
                } catch {
                    fail("Unexpected exception: \(error)")
                }

                fail("Invocation with an unexpected interaction did not throw an exception")
            }
        }
    }
}
