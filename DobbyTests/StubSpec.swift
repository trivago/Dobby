//  Copyright (c) 2015 Rheinfabrik. All rights reserved.

import Quick
import Nimble

import Dobby

class StubSpec: QuickSpec {
    override func spec() {
        var stub: Stub<Int, Int>!

        beforeEach {
            stub = Stub<Int, Int>()
            behave(&(stub!), 1, 2)
            behave(&(stub!), 2, 4)
        }

        describe("Stubbing") {
            it("should append to the stub") {
                expect(stub.behavior[0].interaction).to(equal(1))
                expect(stub.behavior[0].returnValue).to(equal(2))
                expect(stub.behavior[1].interaction).to(equal(2))
                expect(stub.behavior[1].returnValue).to(equal(4))
            }
        }

        describe("Invoking a stub") {
            it("should return the first matching interaction's return value") {
                expect(invoke(stub, 1)).to(equal(2))
            }
        }
    }
}
