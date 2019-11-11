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
