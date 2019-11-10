//
//  EndpointsTests.swift
//  SeeleScanAPITests
//
//  Created by Marcus Florentin on 27/09/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import XCTest
@testable import SeeleScanAPI

class EndpointsTests: XCTestCase {

	private let endpoints : Endpoints = .init()

	static var allTests = [
		("Main URL check", testMainURL),
		("Main URL check", testTransactionsCount),
		("Main URL check", testBlockCount),
		("Main URL check", testAccountCount),
		("Main URL check", testContractCount),
	]

	/// Verify that the endpoint base url is valid
	func testMainURL() {
		let main = URL(string: "https://api.seelescan.net/")!

		// Metrics

		if let base = endpoints.metrics(.txCount).baseURL {
			XCTAssertEqual(base, main, "The enpoints .txCount don't use the main URL")
		} else {
			XCTFail("No base url for a endpoint .txCount")
		}

		if let base = endpoints.metrics(.blockCount).baseURL {
			XCTAssertEqual(base, main, "The enpoints .blockCount don't use the main URL")
		} else {
			XCTFail("No base url for a endpoint .blockCount")
		}

		if let base = endpoints.metrics(.accountCount).baseURL {
			XCTAssertEqual(base, main, "The enpoints .accountCount don't use the main URL")
		} else {
			XCTFail("No base url for a endpoint accountCountt")
		}

		if let base = endpoints.metrics(.contractCount).baseURL {
			XCTAssertEqual(base, main, "The enpoints .contractCount don't use the main URL")
		} else {
			XCTFail("No base url for a endpoint .contractCount")
		}
	}

	// MARK: - Account Tests

	func testAccountList() {
		let valid = URL(string: "https://api.seelescan.net/api/v1/accounts?p=1&ps=10&s=1")!

		// Set parameters
		let param : Set<URLQueryItem> = [.init(page: 1), .init(size: 10), .init(shard: 1)]

		XCTAssertEqual(endpoints.account(.list, param: param).absoluteURL, valid,
					   "Unvalid route for account list request")
	}

	func testAccountDetails() {
		let valid = URL(string: "https://api.seelescan.net/api/v1/account?address=0xf985d0da3b826aa9bcaed96ebaf26e1cd1cf4b51")!

		// Set the parameter
		let param = URLQueryItem(address: "0xf985d0da3b826aa9bcaed96ebaf26e1cd1cf4b51")

		XCTAssertEqual(endpoints.account(.details, param: [param]).absoluteURL, valid,
					   "Unvalid route for account details request")
	}


	// MARK: - Metrics Tests

	/// Test the url for the transaction count request
	func testTransactionsCount() {
		let valid = URL(string: "https://api.seelescan.net/api/v1/txcount")!

		XCTAssertEqual(endpoints.metrics(.txCount).absoluteURL, valid, "Unvalid route for transaction count request")
	}

	/// Test the url for the block count request
	func testBlockCount() {
		let valid = URL(string: "https://api.seelescan.net/api/v1/blockcount")!

		XCTAssertEqual(endpoints.metrics(.blockCount).absoluteURL, valid, "Unvalid route for block count request")
	}

	/// Test the url for the account count request
	func testAccountCount() {
		let valid = URL(string: "https://api.seelescan.net/api/v1/accountcount")!

		XCTAssertEqual(endpoints.metrics(.accountCount).absoluteURL, valid, "Unvalid route for account count request")
	}

	/// Test the url for the contract count request
	func testContractCount() {
		let valid = URL(string: "https://api.seelescan.net/api/v1/contractcount")!

		XCTAssertEqual(endpoints.metrics(.contractCount).absoluteURL, valid, "Unvalid route for contract count request")
	}

}
