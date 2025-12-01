import Quick
import Nimble

@testable import Dobby

class RecorderSpec: QuickSpec {
    override func spec() {
        var recorder: Recorder<Int>!

        beforeEach {
            recorder = Recorder()
        }

        describe("Recording") {
            it("appends an interaction and its corresponding value to the recorder") {
                let currentTimestamp = Dobby.currentTimestamp

                recorder.record(1)

                // Verify that the interaction has been recorded.
                expect(recorder.interactions).to(haveCount(1))
                expect(recorder.interactions[AnyIndex(0)].timestamp).to(equal(currentTimestamp + 1))

                // Verify that the corresponding value has been recorded.
                expect(recorder.valueForInteraction(at: 0)).to(equal(1))

                // Verify that the global clock has been advanced.
                expect(Dobby.currentTimestamp).to(equal(currentTimestamp + 1))
            }
        }
    }
}
