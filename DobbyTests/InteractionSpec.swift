import Quick
import Nimble

import Dobby

class InteractionSpec: QuickSpec {
    override func spec() {
        describe("Comparing two interactions for equality") {
            context("when both have 0 arguments") {
                it("should always succeed") {
                    expect(interaction()).to(equal(interaction()))
                }
            }

            context("when both have 1 argument") {
                it("should compare the arguments") {
                    expect(interaction(Argument.Value(true))).to(equal(interaction(Argument.Value(true))))
                    expect(interaction(Argument.Value(true))).toNot(equal(interaction(Argument.Value(false))))
                }
            }

            context("when both have 2 arguments") {
                it("should compare the arguments") {
                    expect(interaction(true, 1)).to(equal(interaction(true, 1)))
                    expect(interaction(true, 1)).toNot(equal(interaction(false, 1)))
                }
            }

            context("when both have 3 arguments") {
                it("should compare the arguments") {
                    expect(interaction(true, 1, Float(3))).to(equal(interaction(true, 1, Float(3))))
                    expect(interaction(true, 1, Float(3))).toNot(equal(interaction(true, 1, Float(4))))
                }
            }

            context("when both have 4 arguments") {
                it("should compare the arguments") {
                    expect(interaction(true, 1, Float(3), Double(4))).to(equal(interaction(true, 1, Float(3), Double(4))))
                    expect(interaction(true, 1, Float(3), Double(4))).toNot(equal(interaction(true, 1, Float(3), Double(5))))
                }
            }

            context("when both have 5 arguments") {
                it("should compare the arguments") {
                    expect(interaction(true, 1, Float(3), Double(4), "five")).to(equal(interaction(true, 1, Float(3), Double(4), "five")))
                    expect(interaction(true, 1, Float(3), Double(4), "five")).toNot(equal(interaction(true, 1, Float(3), Double(4), "six")))
                }
            }
        }
    }
}
