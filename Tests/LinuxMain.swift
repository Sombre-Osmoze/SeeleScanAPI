import XCTest

import SeeleScanAPITests

var tests = [XCTestCaseEntry]()
tests += SeeleScanAPITests.allTests()
tests += EndpointsTests.allTests()
XCTMain(tests)
