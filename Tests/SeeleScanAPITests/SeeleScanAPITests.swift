//
//  SeeleScanAPITests.swift
//  SeeleScanAPITests
//
//  Created by Marcus Florentin on 27/09/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//


import XCTest
@testable import SeeleScanAPI

@available(OSX 10.15, *)
final class SeeleScanAPITests: XCTestCase {


	let interaction : SeeleScanAPI = .init()

	private var cancels : [Any] = []

	// MARK: - Metrics

	@available(OSX 10.15, *)
	func testTotalTransaction() {

		let expectation = XCTestExpectation(description: "Get the total number of transactions")

		let cancel = interaction.totalTransactions()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					expectation.fulfill()
					break;
				case .failure(let error):
					// TODO: Handle error case

					XCTFail("A error occured")
				}
				expectation.fulfill()

			}, receiveValue: { _ in expectation.fulfill() })

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}


	func testTotalBlocks() {
		let expectation = XCTestExpectation(description: "Get the total number of blocks")

		let cancel = interaction.totalBlocks()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					expectation.fulfill()
					break;
				case .failure(let error):
					// TODO: Handle error case

					XCTFail("A error occured")
				}
				expectation.fulfill()

			}, receiveValue: { _ in expectation.fulfill() })

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}

	func testTotalAccounts() {
		let expectation = XCTestExpectation(description: "Get the total number of blocks")

		let cancel = interaction.totalAccounts()
			.sink(receiveCompletion: { completion in
				switch completion {
				case .finished:
					expectation.fulfill()
					break;
				case .failure(let error):
					// TODO: Handle error case

					XCTFail("A error occured")
				}
				expectation.fulfill()

			}, receiveValue: { _ in expectation.fulfill() })

		cancels.append(cancel)
		wait(for: [expectation], timeout: 10)
	}

    static var allTests = [
        ("Total transaction", testTotalTransaction),
		("Total blocks", testTotalBlocks),
		("Total accounts", testTotalAccounts)
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
