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

	static var allTests = [
		// Node
		("Node list decoding", testDecodeNodeList),
		("Node details decoding", testDecodeNode),
		("Node map decoding", testDecodeNodeMap),
		// Account
		("Account list decoding", testDecodeAccountList),
		("Account details detail decoding", testDecodeAccount),
		// Metrics
		("Transaction count decoding", testDecodeTxCount),
		("Block count decoding", testDecodeBlockCount),
		("Account count decoding", testDecodeAccountCount),
		("Contract count decoding", testDecodeContractCount),
	]

	// MARK: - Node

	let nodeFolder : URL = {
		var url = responsesFolder
		url.appendPathComponent("Node", isDirectory: true)
		return url
	}()

	func testDecodeNodeList() throws {
		let data = try file(named: "nodes", in: nodeFolder)

		XCTAssertNoThrow(try decoder.decode(NodesResponse.self, from: data),
						 "Decoding error for nodes")
	}

	func testDecodeNode() throws {
		let data = try file(named: "node", in: nodeFolder)

		XCTAssertNoThrow(try decoder.decode(NodeResponse.self, from: data),
						 "Decoding error for node")
	}

	func testDecodeNodeMap() throws {
		let data = try file(named: "nodemap", in: nodeFolder)

		XCTAssertNoThrow(try decoder.decode(NodeMapResponse.self, from: data),
						 "Decoding error for nodemap")
	}


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
