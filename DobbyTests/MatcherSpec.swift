import Quick
import Nimble

import Dobby

class MatcherSpec: QuickSpec {
    override func spec() {
        describe("Matching") {
            context("a matching function") {
                let matcher: Dobby.Matcher<Int> = matches { $0 == 0 }

                it("succeeds if the matching function returns true") {
                    expect(matcher.matches(0)).to(beTrue())
                }

                it("fails if the matching function returns false") {
                    expect(matcher.matches(1)).to(beFalse())
                }
            }

            context("anything") {
                let matcher: Dobby.Matcher<Int> = any()

                it("always succeeds") {
                    expect(matcher.matches(0)).to(beTrue())
                    expect(matcher.matches(1)).to(beTrue())
                }
            }

            context("nothing") {
                let matcher: Dobby.Matcher<Int?> = none()

                it("succeeds if the actual value equals nil") {
                    expect(matcher.matches(nil)).to(beTrue())
                }

                it("fails if the actual value does not equal nil") {
                    expect(matcher.matches(0)).to(beFalse())
                }
            }

            context("something") {
                let matcher: Dobby.Matcher<Int?> = some(0)

                it("succeeds if the given matcher is matched") {
                    expect(matcher.matches(0)).to(beTrue())
                }

                it("fails if the given matcher is not matched") {
                    expect(matcher.matches(nil)).to(beFalse())
                    expect(matcher.matches(1)).to(beFalse())
                }
            }

            context("a value") {
                let matcher: Dobby.Matcher<Int> = equals(0)

                it("succeeds if the actual value equals the expected value") {
                    expect(matcher.matches(0)).to(beTrue())
                }

                it("fails if the actual value does not equal the expected value") {
                    expect(matcher.matches(1)).to(beFalse())
                }
            }

            context("a 2-tuple") {
                let matcher: Dobby.Matcher<(Int, Int)> = equals((0, 1))

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches(0, 1)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches(1, 1)).to(beFalse())
                    expect(matcher.matches(0, 0)).to(beFalse())
                }
            }

            context("a 3-tuple") {
                let matcher: Dobby.Matcher<(Int, Int, Int)> = equals((0, 1, 2))

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches(0, 1, 2)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches(1, 1, 2)).to(beFalse())
                    expect(matcher.matches(0, 0, 2)).to(beFalse())
                    expect(matcher.matches(0, 1, 1)).to(beFalse())
                }
            }

            context("a 4-tuple") {
                let matcher: Dobby.Matcher<(Int, Int, Int, Int)> = equals((0, 1, 2, 3))

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches(0, 1, 2, 3)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches(1, 1, 2, 3)).to(beFalse())
                    expect(matcher.matches(0, 0, 2, 3)).to(beFalse())
                    expect(matcher.matches(0, 1, 1, 3)).to(beFalse())
                    expect(matcher.matches(0, 1, 2, 2)).to(beFalse())
                }
            }

            context("a 5-tuple") {
                let matcher: Dobby.Matcher<(Int, Int, Int, Int, Int)> = equals((0, 1, 2, 3, 4))

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches(0, 1, 2, 3, 4)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches(1, 1, 2, 3, 4)).to(beFalse())
                    expect(matcher.matches(0, 0, 2, 3, 4)).to(beFalse())
                    expect(matcher.matches(0, 1, 1, 3, 4)).to(beFalse())
                    expect(matcher.matches(0, 1, 2, 2, 4)).to(beFalse())
                    expect(matcher.matches(0, 1, 2, 3, 3)).to(beFalse())
                }
            }

            context("an array") {
                let matcher: Dobby.Matcher<[Int]> = equals([0, 1, 2])

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches([0, 1, 2])).to(beTrue())
                }

                it("fails if the amount of actual values differs from the amount of expected values") {
                    expect(matcher.matches([0, 1])).to(beFalse())
                    expect(matcher.matches([0, 1, 2, 3])).to(beFalse())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches([1, 1, 2])).to(beFalse())
                    expect(matcher.matches([0, 0, 2])).to(beFalse())
                    expect(matcher.matches([0, 1, 1])).to(beFalse())
                }
            }

            context("a dictionary") {
                let matcher: Dobby.Matcher<[Int: Int]> = equals([0: 0, 1: 1, 2: 2])

                it("succeeds if all actual pairs equal the expected pairs") {
                    expect(matcher.matches([0: 0, 1: 1, 2: 2])).to(beTrue())
                }

                it("fails if the amount of actual pairs differs from the amount of expected pairs") {
                    expect(matcher.matches([0: 0, 1: 1])).to(beFalse())
                    expect(matcher.matches([0: 0, 1: 1, 2: 2, 3: 3])).to(beFalse())
                }

                it("fails if any actual pair does not equal the expected pair") {
                    expect(matcher.matches([0: 1, 1: 1, 2: 2])).to(beFalse())
                    expect(matcher.matches([0: 0, 1: 0, 2: 2])).to(beFalse())
                    expect(matcher.matches([0: 0, 1: 1, 2: 1])).to(beFalse())
                }
            }

            context("a 2-tuple of matchers") {
                let matcher: Dobby.Matcher<(Int, Int)> = matches((equals(0), equals(1)))

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches(0, 1)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches(1, 1)).to(beFalse())
                    expect(matcher.matches(0, 0)).to(beFalse())
                }
            }

            context("a 3-tuple of matchers") {
                let matcher: Dobby.Matcher<(Int, Int, Int)> = matches((equals(0), equals(1), equals(2)))

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches(0, 1, 2)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches(1, 1, 2)).to(beFalse())
                    expect(matcher.matches(0, 0, 2)).to(beFalse())
                    expect(matcher.matches(0, 1, 1)).to(beFalse())
                }
            }

            context("a 4-tuple of matchers") {
                let matcher: Dobby.Matcher<(Int, Int, Int, Int)> = matches((equals(0), equals(1), equals(2), equals(3)))

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches(0, 1, 2, 3)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches(1, 1, 2, 3)).to(beFalse())
                    expect(matcher.matches(0, 0, 2, 3)).to(beFalse())
                    expect(matcher.matches(0, 1, 1, 3)).to(beFalse())
                    expect(matcher.matches(0, 1, 2, 2)).to(beFalse())
                }
            }

            context("a 5-tuple of matchers") {
                let matcher: Dobby.Matcher<(Int, Int, Int, Int, Int)> = matches((equals(0), equals(1), equals(2), equals(3), equals(4)))

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches(0, 1, 2, 3, 4)).to(beTrue())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches(1, 1, 2, 3, 4)).to(beFalse())
                    expect(matcher.matches(0, 0, 2, 3, 4)).to(beFalse())
                    expect(matcher.matches(0, 1, 1, 3, 4)).to(beFalse())
                    expect(matcher.matches(0, 1, 2, 2, 4)).to(beFalse())
                    expect(matcher.matches(0, 1, 2, 3, 3)).to(beFalse())
                }
            }

            context("an array of matchers") {
                let matcher: Dobby.Matcher<[Int]> = matches([equals(0), equals(1), equals(2)])

                it("succeeds if all actual values equal the expected values") {
                    expect(matcher.matches([0, 1, 2])).to(beTrue())
                }

                it("fails if the amount of actual values differs from the amount of expected values") {
                    expect(matcher.matches([0, 1])).to(beFalse())
                    expect(matcher.matches([0, 1, 2, 3])).to(beFalse())
                }

                it("fails if any actual value does not equal the expected value") {
                    expect(matcher.matches([1, 1, 2])).to(beFalse())
                    expect(matcher.matches([0, 0, 2])).to(beFalse())
                    expect(matcher.matches([0, 1, 1])).to(beFalse())
                }
            }

            context("a dictionary of matchers") {
                let matcher: Dobby.Matcher<[Int: Int]> = matches([0: equals(0), 1: equals(1), 2: equals(2)])

                it("succeeds if all actual pairs equal the expected pairs") {
                    expect(matcher.matches([0: 0, 1: 1, 2: 2])).to(beTrue())
                }

                it("fails if the amount of actual pairs differs from the amount of expected pairs") {
                    expect(matcher.matches([0: 0, 1: 1])).to(beFalse())
                    expect(matcher.matches([0: 0, 1: 1, 2: 2, 3: 3])).to(beFalse())
                }

                it("fails if any actual pair does not equal the expected pair") {
                    expect(matcher.matches([0: 1, 1: 1, 2: 2])).to(beFalse())
                    expect(matcher.matches([0: 0, 1: 0, 2: 2])).to(beFalse())
                    expect(matcher.matches([0: 0, 1: 1, 2: 1])).to(beFalse())
                }
            }
        }
    }
}
