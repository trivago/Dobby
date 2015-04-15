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
                    expect(interaction(1)).to(equal(interaction(1)))
                    expect(interaction(1)).toNot(equal(interaction(2)))
                }
            }

            context("when both have 2 arguments") {
                it("should compare the arguments") {
                    expect(interaction(1, 2)).to(equal(interaction(1, 2)))
                    expect(interaction(1, 2)).toNot(equal(interaction(1, 3)))
                }
            }

            context("when both have 3 arguments") {
                it("should compare the arguments") {
                    expect(interaction(1, 2, 3)).to(equal(interaction(1, 2, 3)))
                    expect(interaction(1, 2, 3)).toNot(equal(interaction(1, 2, 4)))
                }
            }

            context("when both have 4 arguments") {
                it("should compare the arguments") {
                    expect(interaction(1, 2, 3, 4)).to(equal(interaction(1, 2, 3, 4)))
                    expect(interaction(1, 2, 3, 4)).toNot(equal(interaction(1, 2, 3, 5)))
                }
            }

            context("when both have 5 arguments") {
                it("should compare the arguments") {
                    expect(interaction(1, 2, 3, 4, 5)).to(equal(interaction(1, 2, 3, 4, 5)))
                    expect(interaction(1, 2, 3, 4, 5)).toNot(equal(interaction(1, 2, 3, 4, 6)))
                }
            }
        }
    }
}
