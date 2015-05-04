// Copyright 2014 Quick Team
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Nimble
import XCTest

func failsWithErrorMessage(message: String, file: String = __FILE__, line: UInt = __LINE__, preferOriginalSourceLocation: Bool = false, closure: () -> Void) {
    var filePath = file
    var lineNumber = line

    let recorder = AssertionRecorder()
    withAssertionHandler(recorder, closure)

    var lastFailure: AssertionRecord?
    if recorder.assertions.count > 0 {
        lastFailure = recorder.assertions[recorder.assertions.endIndex - 1]
        if lastFailure!.message == message {
            return
        }
    }

    if preferOriginalSourceLocation {
        if let failure = lastFailure {
            filePath = failure.location.file
            lineNumber = failure.location.line
        }
    }

    if lastFailure != nil {
        let msg = "Got failure message: \"\(lastFailure!.message)\", but expected \"\(message)\""
        XCTFail(msg, file: filePath, line: lineNumber)
    } else {
        XCTFail("expected failure message, but got none", file: filePath, line: lineNumber)
    }
}

func failsWithErrorMessageForNil(message: String, file: String = __FILE__, line: UInt = __LINE__, preferOriginalSourceLocation: Bool = false, closure: () -> Void) {
    failsWithErrorMessage("\(message) (use beNil() to match nils)", file: file, line: line, preferOriginalSourceLocation: preferOriginalSourceLocation, closure)
}
