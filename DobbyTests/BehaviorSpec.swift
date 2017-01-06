import Quick
import Nimble

@testable import Dobby

class BehaviorSpec: QuickSpec {
    override func spec() {
        var behavior: Behavior!

        var recorder1: Recorder<Int>!
        var recorder2: Recorder<Int>!

        beforeEach {
            recorder1 = Recorder()
            recorder2 = Recorder()
        }

        describe("Verification") {
            context("when the behavior is strict and the order of expectations does matter") {
                beforeEach {
                    behavior = Behavior(strict: true, ordered: true)
                }

                it("succeeds if all set up expectations are fulfilled") {
                    recorder1.record(1)
                    recorder2.record(2)

                    behavior.expect(1, in: recorder1)
                    behavior.expect(2, in: recorder2)
                    behavior.verify()
                }

                it("fails if an interaction does not match the current expectation") {
                    recorder1.record(1)
                    recorder2.record(2)

                    behavior.expect(1, in: recorder1)
                    behavior.expect(3, in: recorder2)

                    var failureMessages: [String] = []

                    behavior.verify(fail: { message, _, _ in
                        failureMessages.append(message)
                    })

                    expect(failureMessages).to(equal([
                        "Interaction <2> does not match expectation <3>",
                        "Expectation <3> not fulfilled"
                    ]))
                }

                it("fails if an interaction is not expected") {
                    recorder1.record(1)
                    recorder1.record(2)

                    behavior.expect(1, in: recorder1)

                    var failureMessages: [String] = []

                    behavior.verify(fail: { message, _, _ in
                        failureMessages.append(message)
                    })

                    expect(failureMessages).to(equal([
                        "Interaction <2> not expected"
                    ]))
                }

                it("fails if any expectation is not fulfilled") {
                    recorder1.record(1)

                    behavior.expect(1, in: recorder1)
                    behavior.expect(2, in: recorder2)

                    var failureMessages: [String] = []

                    behavior.verify(fail: { message, _, _ in
                        failureMessages.append(message)
                    })

                    expect(failureMessages).to(equal([
                        "Expectation <2> not fulfilled"
                    ]))
                }
            }

            context("when the behavior is strict and the order of expectations does not matter") {
                beforeEach {
                    behavior = Behavior(strict: true, ordered: false)
                }

                it("succeeds if all set up expectations are fulfilled") {
                    recorder2.record(2)
                    recorder1.record(1)

                    behavior.expect(1, in: recorder1)
                    behavior.expect(2, in: recorder2)
                    behavior.verify()
                }

                it("fails if an interaction is not expected") {
                    recorder1.record(2)
                    recorder1.record(1)

                    behavior.expect(1, in: recorder1)

                    var failureMessages: [String] = []

                    behavior.verify(fail: { message, _, _ in
                        failureMessages.append(message)
                    })

                    expect(failureMessages).to(equal([
                        "Interaction <2> not expected"
                    ]))
                }

                it("fails if any expectation is not fulfilled") {
                    recorder1.record(1)

                    behavior.expect(2, in: recorder2)
                    behavior.expect(1, in: recorder1)

                    var failureMessages: [String] = []

                    behavior.verify(fail: { message, _, _ in
                        failureMessages.append(message)
                    })

                    expect(failureMessages).to(equal([
                        "Expectation <2> not fulfilled"
                    ]))
                }
            }

            context("when the behavior is nice and the order of expectations does matter") {
                beforeEach {
                    behavior = Behavior(nice: true, ordered: true)
                }

                it("succeeds if all set up expectations are fulfilled") {
                    recorder1.record(1)
                    recorder2.record(2)
                    recorder1.record(3)
                    recorder2.record(4)

                    behavior.expect(1, in: recorder1)
                    behavior.expect(2, in: recorder2)
                    behavior.verify()
                }

                it("fails if expectations are not fulfilled in order") {
                    recorder1.record(3)
                    recorder1.record(2)
                    recorder1.record(1)

                    behavior.expect(1, in: recorder1)
                    behavior.expect(2, in: recorder1)

                    var failureMessages: [String] = []

                    behavior.verify(fail: { message, _, _ in
                        failureMessages.append(message)
                    })

                    expect(failureMessages).to(equal([
                        "Expectation <2> not fulfilled"
                    ]))
                }

                it("fails if any expectation is not fulfilled") {
                    recorder1.record(1)

                    behavior.expect(1, in: recorder1)
                    behavior.expect(2, in: recorder2)

                    var failureMessages: [String] = []

                    behavior.verify(fail: { message, _, _ in
                        failureMessages.append(message)
                    })

                    expect(failureMessages).to(equal([
                        "Expectation <2> not fulfilled"
                    ]))
                }
            }

            context("when the behavior is nice and the order of expectations does not matter") {
                beforeEach {
                    behavior = Behavior(nice: true, ordered: false)
                }

                it("succeeds if all set up expectations are fulfilled") {
                    recorder2.record(4)
                    recorder1.record(3)
                    recorder2.record(2)
                    recorder1.record(1)

                    behavior.expect(1, in: recorder1)
                    behavior.expect(2, in: recorder2)
                    behavior.verify()
                }

                it("fails if any expectation is not fulfilled") {
                    recorder1.record(1)

                    behavior.expect(2, in: recorder2)
                    behavior.expect(1, in: recorder1)

                    var failureMessages: [String] = []

                    behavior.verify(fail: { message, _, _ in
                        failureMessages.append(message)
                    })

                    expect(failureMessages).to(equal([
                        "Expectation <2> not fulfilled"
                    ]))
                }
            }
        }

        describe("Verification with a timeout") {
            beforeEach {
                behavior = Behavior()
            }

            it("succeeds if all expectations are fulfilled before the timeout is reached") {
                let mainQueue: DispatchQueue = .main
                mainQueue.asyncAfter(deadline: .now() + 0.25) {
                    recorder1.record(1)
                }

                behavior.expect(1, in: recorder1)
                behavior.verify(timeout: 0.5)
            }

            it("fails if any expectation is not fulfilled before the timeout is reached") {
                behavior.expect(1, in: recorder1)

                var failureMessages: [String] = []

                behavior.verify(fail: { message, _, _ in
                    failureMessages.append(message)
                })

                expect(failureMessages).to(equal([
                    "Expectation <1> not fulfilled"
                ]))
            }
        }
    }
}
