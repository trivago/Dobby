import Quick
import Nimble

import Dobby

class ArgumentSpec: QuickSpec {
    override func spec() {
        describe("Comparing two arguments for equality") {
            context("when both are values") {
                it("should compare the contained values for equality") {
                    expect(value(1) == value(1)).to(beTrue())
                    expect(value(1) == value(2)).to(beFalse())
                }
            }

            context("when one is a value and one is a filter") {
                it("should use the filter") {
                    expect(value(1) == filter { (x: Int) in x == 1 }).to(beTrue())
                    expect(filter { (x: Int) in x == 1 } == value(2)).to(beFalse())
                }
            }

            context("when one matches anything") {
                it("should always succeed") {
                    expect(value(1) == any()).to(beTrue())
                    expect(any() == value(1)).to(beTrue())
                    expect(filter { (x: Int) in x == 1 } == any()).to(beTrue())
                    expect(any() == filter { (x: Int) in x == 1 }).to(beTrue())
                    expect(any() as Argument<Int> == any() as Argument<Int>).to(beTrue())
                }
            }

            context("when both are filters") {
                it("should always fail") {
                    expect(filter { (x: Int) in x == 1 } == filter { (x: Int) in x == 1 }).to(beFalse())
                }
            }
        }
    }
}
