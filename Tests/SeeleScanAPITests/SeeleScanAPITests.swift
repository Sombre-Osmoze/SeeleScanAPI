//
//  SeeleScanAPITests.swift
//  SeeleScanAPITests
//
//  Created by Marcus Florentin on 27/09/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//


import XCTest
@testable import SeeleScanAPI

final class SeeleScanAPITests: XCTestCase {


	let interaction : SeeleScanAPI = .init()

	private var cancels : [Any] = []

	// MARK: - Node

	func testNodeList() {
		let page = 1
		let size = 30
		let shard = 1

		let expectation = XCTestExpectation(description: "Get a \(size) node list in page 1")

		let cancel = interaction.nodeList(page: page, size: size, shard: shard)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break;
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectation.fulfill()
			}) { list, info in
				XCTAssertEqual(info.curPage, page, "Icorrect page fetched")
				XCTAssertEqual(list.count, size, "Incorrect page size")
		}

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}

	func testNodeDetail() {
		let id = "0xb6f7b8641e53f216e45b840c30929eb9832a0a81"

		let expectation = XCTestExpectation(description: "Fetch node \(id) details")


		let cancel = interaction.node(id: id)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break;
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectation.fulfill()
			}) { account in
				XCTAssertEqual(account.id, id, "Fetched wrong node")
		}

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}

	func testNodeMap() {

		let expectation = XCTestExpectation(description: "Get a node map")

		let cancel = interaction.nodeMap()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break;
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectation.fulfill()
			}) { _ in }

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}


	// MARK: - Account

	#if canImport(Combine)

	func testAccountList() {
		let page = 1
		let size = 30
		let shard = 1

		let expectation = XCTestExpectation(description: "Get a \(size) account list in page 1")

		let cancel = interaction.accountList(page: page, size: size, shard: shard)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break;
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectation.fulfill()
			}) { list, info in
				XCTAssertEqual(info.curPage, page, "Icorrect page fetched")
				XCTAssertEqual(list.count, size, "Incorrect page size")
		}

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}

	func testAccountDetail() {
		let address = "0xf985d0da3b826aa9bcaed96ebaf26e1cd1cf4b51"

		let expectation = XCTestExpectation(description: "Fetch account \(address) details")


		let cancel = interaction.account(address: address)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break;
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectation.fulfill()
			}) { account in
				XCTAssertEqual(account.address, address, "Fetched wrong account")
		}

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}

	#endif


	// MARK: - Metrics

	#if canImport(Combine)

	func testTotalTransaction() {

		let expectation = XCTestExpectation(description: "Get the total number of transactions")

		let cancel = interaction.totalTransactions()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break;
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectation.fulfill()

			}, receiveValue: { _ in })

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}


	func testTotalBlocks() {
		let expectation = XCTestExpectation(description: "Get the total number of blocks")

		let cancel = interaction.totalBlocks()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break;
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectation.fulfill()

			}, receiveValue: { _ in })

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}

	func testTotalAccounts() {
		let expectation = XCTestExpectation(description: "Get the total number of accounts")

		let cancel = interaction.totalAccounts()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break;
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectation.fulfill()

			}, receiveValue: { _ in })

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}

	func testTotalContracts() {
		let expectation = XCTestExpectation(description: "Get the total number of contracts")

		let cancel = interaction.totalContracts()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					break;
				case .failure(let error):
					XCTFail(error.localizedDescription)
				}
				expectation.fulfill()

			}, receiveValue: { _ in })

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}

	#endif

    static var allTests = [
		// Node
		("Node list", testNodeList)
		("Node details", testNodeDetail)
		("Node map", testNodeMap)
		// Account
		("Account list", testAccountList)
		("Account detail", testAccountDetail)
		// Metrics
        ("Total transaction", testTotalTransaction),
		("Total blocks", testTotalBlocks),
		("Total accounts", testTotalAccounts),
		("Total contracts", testTotalContracts)
    ]
}

// MARK: - Testing Data

let testFolder : URL = {
	var url = URL(fileURLWithPath: #file)
	url.deleteLastPathComponent()
	url.appendPathComponent("Data", isDirectory: true)
	return url
}()

func file(named name: String, ext: String? = "json", in folder: URL = testFolder) throws -> Data {
	var url = folder.appendingPathComponent(name, isDirectory: false)

	if let ext = ext {
		url.appendPathExtension(ext)
	}

	return try Data(contentsOf: url)
}
