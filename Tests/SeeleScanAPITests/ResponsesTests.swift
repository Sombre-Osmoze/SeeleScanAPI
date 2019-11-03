//
//  ResponsesTests.swift
//  SeeleScanAPITests
//
//  Created by Marcus Florentin on 27/09/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import XCTest
@testable import SeeleScanAPI

fileprivate let responsesFolder : URL = {
	var url = testFolder
	url.appendPathComponent("Responses", isDirectory: true)
	return url
}()

class ResponsesTests: XCTestCase {

	private var bundle : Bundle = .init(for: ResponsesTests.self)


    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


	// MARK: - Metrics

	let metricsFolder : URL = {
		var url = responsesFolder
		url.appendPathComponent("Metrics", isDirectory: true)
		return url
	}()

	func testDecodeTxCount() throws {
		let data = try file(named: "txcount", in: metricsFolder)

		XCTAssertNoThrow(try decoder.decode(MetricResponse.self, from: data), "Decoding error for txcount")
	}

	func testDecodeBlockCount() throws {
		let data = try file(named: "blockcount", in: metricsFolder)

		XCTAssertNoThrow(try decoder.decode(MetricResponse.self, from: data), "Decoding error for blockcount")
	}

	func testDecodeAccountCount() throws {
		let data = try file(named: "accountcount", in: metricsFolder)


		XCTAssertNoThrow(try decoder.decode(MetricResponse.self, from: data), "Decoding error for accountcount")
	}

	func testDecodeContractCount() throws {
		let data = try file(named: "contractcount", in: metricsFolder)


		XCTAssertNoThrow(try decoder.decode(MetricResponse.self, from: data), "Decoding error for contractcount")
	}


}
