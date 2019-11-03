import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SeeleScanAPITests.allTests),
		testCase(EndpointsTests.allTests),
    ]
}
#endif
