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
		// Node
		("Node list URL check", testNodeList),
		("Node details URL check", testNodeDetails),
		("Node map URL check", testNodeMap),
		// Account
		("Account list URL check", testAccountList),
		("Account details URL check", testAccountDetails),
		// Metrics
		("Transaction count URL check", testTransactionsCount),
		("Block count URL check", testBlockCount),
		("Account count URL check", testAccountCount),
		("Contract count URL check", testContractCount),
	]

	/// Verify that the endpoint base url is valid
	func testMainURL() {
		let main = URL(string: "https://api.seelescan.net/")!

		// Node

		if let base = endpoints.node(.list).baseURL {
			XCTAssertEqual(base, main, "The enpoints .list don't use the main URL")
		} else {
			XCTFail("No base url for a endpoint .list")
		}

		if let base = endpoints.node(.details).baseURL {
			XCTAssertEqual(base, main, "The enpoints .details don't use the main URL")
		} else {
			XCTFail("No base url for a endpoint .details")
		}

		if let base = endpoints.node(.map).baseURL {
			XCTAssertEqual(base, main, "The enpoints .map don't use the main URL")
		} else {
			XCTFail("No base url for a endpoint .map")
		}

		// Account

		if let base = endpoints.account(.list).baseURL {
			XCTAssertEqual(base, main, "The enpoints .list don't use the main URL")
		} else {
			XCTFail("No base url for a endpoint .list")
		}

		if let base = endpoints.account(.details).baseURL {
			XCTAssertEqual(base, main, "The enpoints .details don't use the main URL")
		} else {
			XCTFail("No base url for a endpoint .details")
		}

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

	// MARK: - Node Tests

	func testNodeList() {
		let valid = URL(string: "https://api.seelescan.net/api/v1/nodes?p=1&ps=10&s=1")!

		// Set parameters
		let param : Set<URLQueryItem> = [.init(page: 1), .init(size: 10), .init(shard: 1)]

		XCTAssertEqual(endpoints.node(.list, param: param).absoluteURL, valid,
					   "Unvalid route for node list request")
	}

	func testNodeDetails() {
		let valid = URL(string: "https://api.seelescan.net/api/v1/node?id=0xb6f7b8641e53f216e45b840c30929eb9832a0a81")!

		// Set the parameters
		let param = URLQueryItem(id: "0xb6f7b8641e53f216e45b840c30929eb9832a0a81")

		XCTAssertEqual(endpoints.node(.details, param: [param]).absoluteURL, valid,
					   "Unvalid route for node details request")
	}

	func testNodeMap() {
		let valid = URL(string: "https://api.seelescan.net/api/v1/nodemap")!

		XCTAssertEqual(endpoints.node(.map).absoluteURL, valid,
					   "Unvalid route for node map request")
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
