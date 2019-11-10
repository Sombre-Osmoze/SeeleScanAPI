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

	// MARK: - Account

	let accountFolder : URL = {
		var url = responsesFolder
		url.appendPathComponent("Account", isDirectory: true)
		return url
	}()

	func testDecodeAccountList() throws {
		let data = try file(named: "accounts", in: accountFolder)

		XCTAssertNoThrow(try decoder.decode(AccountsResponse.self, from: data),
						 "Decoding error for accounts")
	}

	func testDecodeAccount() throws {
		let data = try file(named: "account", in: accountFolder)

		XCTAssertNoThrow(try decoder.decode(AccountResponse.self, from: data),
						 "Decoding error for account")
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
