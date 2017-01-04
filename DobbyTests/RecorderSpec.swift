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
            it("appends an interaction to the recorder") {
                let currentTimestamp = Dobby.currentTimestamp

                recorder.record(1)

                // Verify that the interaction has been appended.
                expect(recorder.interactions).to(haveCount(1))
                expect(recorder.interactions[0].timestamp).to(equal(currentTimestamp))
                expect(recorder.interactions[0].value).to(equal(1))

                // Verify that the global clock is advanced.
                expect(Dobby.currentTimestamp).to(equal(currentTimestamp + 1))
            }
        }
    }
}
