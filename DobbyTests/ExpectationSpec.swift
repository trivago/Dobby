import Quick
import Nimble

import Dobby

class ExpectationSpec: QuickSpec {
    override func spec() {
        describe("Matching") {
            context("a matching function") {
                let expectation: Dobby.Expectation<Int> = matches { $0 == 0 }

                it("succeeds if the matching function returns true") {
                    expect(expectation.matches(0)).to(beTrue())
                }

                it("fails if the matching function returns false") {
                    expect(expectation.matches(1)).to(beFalse())
                }
            }

            context("anything") {
                let expectation: Dobby.Expectation<Int> = any()

                it("always succeeds") {
                    expect(expectation.matches(0)).to(beTrue())
                    expect(expectation.matches(1)).to(beTrue())
                }
            }

            context("nothing") {
                let expectation: Dobby.Expectation<Int?> = none()

                it("succeeds if the actual value equals nil") {
                    expect(expectation.matches(nil)).to(beTrue())
                }

                it("fails if the actual value does not equal nil") {
                    expect(expectation.matches(0)).to(beFalse())
                }
            }

            context("something") {
                let expectation: Dobby.Expectation<Int?> = some(0)

                it("succeeds if the given expectation is matched") {
                    expect(expectation.matches(0)).to(beTrue())
                }

                it("fails if the given expectation is not matched") {
                    expect(expectation.matches(nil)).to(beFalse())
                    expect(expectation.matches(1)).to(beFalse())
                }
            }

            context("a value") {
                let expectation: Dobby.Expectation<Int> = equals(0)

                it("succeeds if the actual value equals the expected value") {
                    expect(expectation.matches(0)).to(beTrue())
                }

                it("fails if the actual value does not equal the expected value") {
                    expect(expectation.matches(1)).to(beFalse())
                }
            }

            context("a 2-tuple") {
                let expectation: Dobby.Expectation<(Int, Int)> = equals((0, 1))

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches(0, 1)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches(1, 1)).to(beFalse())
                    expect(expectation.matches(0, 0)).to(beFalse())
                }
            }

            context("a 3-tuple") {
                let expectation: Dobby.Expectation<(Int, Int, Int)> = equals((0, 1, 2))

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches(0, 1, 2)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches(1, 1, 2)).to(beFalse())
                    expect(expectation.matches(0, 0, 2)).to(beFalse())
                    expect(expectation.matches(0, 1, 1)).to(beFalse())
                }
            }

            context("a 4-tuple") {
                let expectation: Dobby.Expectation<(Int, Int, Int, Int)> = equals((0, 1, 2, 3))

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches(0, 1, 2, 3)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches(1, 1, 2, 3)).to(beFalse())
                    expect(expectation.matches(0, 0, 2, 3)).to(beFalse())
                    expect(expectation.matches(0, 1, 1, 3)).to(beFalse())
                    expect(expectation.matches(0, 1, 2, 2)).to(beFalse())
                }
            }

            context("a 5-tuple") {
                let expectation: Dobby.Expectation<(Int, Int, Int, Int, Int)> = equals((0, 1, 2, 3, 4))

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches(0, 1, 2, 3, 4)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches(1, 1, 2, 3, 4)).to(beFalse())
                    expect(expectation.matches(0, 0, 2, 3, 4)).to(beFalse())
                    expect(expectation.matches(0, 1, 1, 3, 4)).to(beFalse())
                    expect(expectation.matches(0, 1, 2, 2, 4)).to(beFalse())
                    expect(expectation.matches(0, 1, 2, 3, 3)).to(beFalse())
                }
            }

            context("an array") {
                let expectation: Dobby.Expectation<[Int]> = equals([0, 1, 2])

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches([0, 1, 2])).to(beTrue())
                }

                it("fails if the amount of actual values differs from the amount of expected values") {
                    expect(expectation.matches([0, 1])).to(beFalse())
                    expect(expectation.matches([0, 1, 2, 3])).to(beFalse())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches([1, 1, 2])).to(beFalse())
                    expect(expectation.matches([0, 0, 2])).to(beFalse())
                    expect(expectation.matches([0, 1, 1])).to(beFalse())
                }
            }

            context("a dictionary") {
                let expectation: Dobby.Expectation<[Int: Int]> = equals([0: 0, 1: 1, 2: 2])

                it("succeeds if all actual pairs equal the expected pairs") {
                    expect(expectation.matches([0: 0, 1: 1, 2: 2])).to(beTrue())
                }

                it("fails if the amount of actual pairs differs from the amount of expected pairs") {
                    expect(expectation.matches([0: 0, 1: 1])).to(beFalse())
                    expect(expectation.matches([0: 0, 1: 1, 2: 2, 3: 3])).to(beFalse())
                }

                it("fails if any actual pair does not equal the expected pair") {
                    expect(expectation.matches([0: 1, 1: 1, 2: 2])).to(beFalse())
                    expect(expectation.matches([0: 0, 1: 0, 2: 2])).to(beFalse())
                    expect(expectation.matches([0: 0, 1: 1, 2: 1])).to(beFalse())
                }
            }

            context("a 2-tuple of expectations") {
                let expectation: Dobby.Expectation<(Int, Int)> = matches((equals(0), equals(1)))

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches(0, 1)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches(1, 1)).to(beFalse())
                    expect(expectation.matches(0, 0)).to(beFalse())
                }
            }

            context("a 3-tuple of expectations") {
                let expectation: Dobby.Expectation<(Int, Int, Int)> = matches((equals(0), equals(1), equals(2)))

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches(0, 1, 2)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches(1, 1, 2)).to(beFalse())
                    expect(expectation.matches(0, 0, 2)).to(beFalse())
                    expect(expectation.matches(0, 1, 1)).to(beFalse())
                }
            }

            context("a 4-tuple of expectations") {
                let expectation: Dobby.Expectation<(Int, Int, Int, Int)> = matches((equals(0), equals(1), equals(2), equals(3)))

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches(0, 1, 2, 3)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches(1, 1, 2, 3)).to(beFalse())
                    expect(expectation.matches(0, 0, 2, 3)).to(beFalse())
                    expect(expectation.matches(0, 1, 1, 3)).to(beFalse())
                    expect(expectation.matches(0, 1, 2, 2)).to(beFalse())
                }
            }

            context("a 5-tuple of expectations") {
                let expectation: Dobby.Expectation<(Int, Int, Int, Int, Int)> = matches((equals(0), equals(1), equals(2), equals(3), equals(4)))

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches(0, 1, 2, 3, 4)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches(1, 1, 2, 3, 4)).to(beFalse())
                    expect(expectation.matches(0, 0, 2, 3, 4)).to(beFalse())
                    expect(expectation.matches(0, 1, 1, 3, 4)).to(beFalse())
                    expect(expectation.matches(0, 1, 2, 2, 4)).to(beFalse())
                    expect(expectation.matches(0, 1, 2, 3, 3)).to(beFalse())
                }
            }

            context("an array of expectations") {
                let expectation: Dobby.Expectation<[Int]> = matches([equals(0), equals(1), equals(2)])

                it("succeeds if all actual values equal the expected values") {
                    expect(expectation.matches([0, 1, 2])).to(beTrue())
                }

                it("fails if the amount of actual values differs from the amount of expected values") {
                    expect(expectation.matches([0, 1])).to(beFalse())
                    expect(expectation.matches([0, 1, 2, 3])).to(beFalse())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(expectation.matches([1, 1, 2])).to(beFalse())
                    expect(expectation.matches([0, 0, 2])).to(beFalse())
                    expect(expectation.matches([0, 1, 1])).to(beFalse())
                }
            }

            context("a dictionary of expectations") {
                let expectation: Dobby.Expectation<[Int: Int]> = matches([0: equals(0), 1: equals(1), 2: equals(2)])

                it("succeeds if all actual pairs equal the expected pairs") {
                    expect(expectation.matches([0: 0, 1: 1, 2: 2])).to(beTrue())
                }

                it("fails if the amount of actual pairs differs from the amount of expected pairs") {
                    expect(expectation.matches([0: 0, 1: 1])).to(beFalse())
                    expect(expectation.matches([0: 0, 1: 1, 2: 2, 3: 3])).to(beFalse())
                }

                it("fails if any actual pair does not equal the expected pair") {
                    expect(expectation.matches([0: 1, 1: 1, 2: 2])).to(beFalse())
                    expect(expectation.matches([0: 0, 1: 0, 2: 2])).to(beFalse())
                    expect(expectation.matches([0: 0, 1: 1, 2: 1])).to(beFalse())
                }
            }
        }
    }
}
