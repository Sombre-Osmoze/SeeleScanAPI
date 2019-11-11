//
//  SeeleScanAPI.swift
//  SeeleScanAPI
//
//  Created by Marcus Florentin on 27/09/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation
import Logging

#if canImport(Combine)
import Combine
#endif

#if canImport(os)
import os.signpost
#endif

public class SeeleScanAPI {

	// MARK: - Logs

	private let logger = Logger(label: "org.sombre-osmoze.SeeleScanAPI")

	#if canImport(os)
	private let logging = OSLog(subsystem: "org.sombre-osmoze.SeeleScanAPI", category: "Network Request")
	#endif

	// MARK: - SeeleScanAPI

	/// All the endpoints need to communicate with the api
	private var endpoints : Endpoints = .init()


	// MARK: - URLSession

	private let session : URLSession


	public init() {
		session = .init(configuration: .default)

		logger.info("Interaction created.")
	}


	// MARK: - Response and Error

	// MARK: Response and request
	#if canImport(Combine)

	@available(OSX 10.15, *)
	private func prepare<T: ResponseAPI>(_ url: URL, for type: T.Type = T.self, log: StaticString) -> AnyPublisher<T, ErrorAPI> {
		session.dataTaskPublisher(for: url)
			// Check if the request failed.
			.mapError({ self.handle(error: $0, log: log) })
			// Verify the response and decoding the data.
			.tryMap({ try self.verify(response: $1, data: $0, for: T.self, log: log) })
			// Handle decodign errors.
			.mapError({ self.handle(error: $0, log : log) })
			.eraseToAnyPublisher()
	}

	#endif

	private func verify<T: ResponseAPI>(response: URLResponse, data: Data, for type: T.Type = T.self, log: StaticString) throws -> T {

		guard let answer = response as? HTTPURLResponse else { throw ErrorAPI.Response.corrupted }

		switch answer.statusCode {
		case 200:
			return try decoder.decode(T.self, from: data)
		default:
			logger.error("\(log): Unknow status code \(answer.statusCode)")
			throw ErrorAPI.Response.badStatus(answer.statusCode)
		}
	}

	// MARK: Error

	public struct ErrorAPI: Error {

		public var localizedDescription: String

		enum Response: Error {
			case corrupted
			case badStatus(Int)
		}

		init(url error: URLError) {
			localizedDescription = "A error occurred while connecting to the server."
		}

		init(decoding: DecodingError) {
			localizedDescription = "A error occur while processing data from the server."
		}

		init() {
			localizedDescription = "A unknow error occur."
		}
	}


	@available(OSX 10.15, *)
	private func handle(error: Error, log: StaticString) -> ErrorAPI {

		switch error {
		case let decode as DecodingError:
			#if canImport(os)
			os_signpost(.end, log: logging, name: log, "Decoding error: %s", decode.localizedDescription)
			#endif
			logger.error("""
				\(log): Decoding error \(decode.localizedDescription)
				Fail: \(decode.helpAnchor ?? "None")
				Try: \(decode.recoverySuggestion ?? "Something")
				Full error -> \(decode.errorDescription ?? "None provided")
				""")

			return ErrorAPI(decoding: decode)

		case let url as URLError:
			#if canImport(os)
			os_signpost(.end, log: logging, name: log, "URL error: %s, code: %d", url.localizedDescription, url.errorCode)
			#endif

			// TODO: Improve error log
			logger.error("\(log): URL error: \(url.localizedDescription), code: \(url.errorCode)")
			return ErrorAPI(url: url)

		default:
			#if canImport(os)
			os_signpost(.end, log: logging, name: log, "Unknow error: %s", error.localizedDescription)
			#endif

			logger.error("\(log): \(error.localizedDescription)")
			return ErrorAPI()
		}
	}

	// MARK: - Account

	#if canImport(Combine)
	/// Get a list of accounts
	/// - Parameters:
	///   - page: The page number to display
	///   - size: The number of pages displayed, the default value is 25
	///   - shard: The shardNumber
	public func accountList(page: Int, size: Int = 25, shard: Int) -> AnyPublisher<([Account], AccountPage), ErrorAPI> {
		let log : StaticString = "Account list"

		// Set parameters
		let param : Set<URLQueryItem> = [.init(page: page), .init(size: size), .init(shard: shard)]

		#if canImport(os)
		os_signpost(.begin, log: logging, name: log, "%d account for page %d in shard %d", page, size, shard)
		#endif
		return prepare(endpoints.account(.list, param: param), for: AccountsResponse.self, log: log)
			.map { response -> ([Account], AccountPage) in
				let info = response.data.pageInfo

				#if canImport(os)
				os_signpost(.end, log: self.logging, name: log,
							"%d accounts for page %d in %d/%d\n Total balance: %d, Total: %d",
							response.data.list, info.curPage, info.begin, info.end,
							info.totalBalance, info.totalCount)
				#endif
				return (response.data.list, info)
		}
		.eraseToAnyPublisher()

	}
	#endif

	#if canImport(Combine)
	public func account(address: String) -> AnyPublisher<Account, ErrorAPI> {
		let log : StaticString = "Account details"

		let param : URLQueryItem = .init(address: address)

		#if canImport(os)
		os_signpost(.begin, log: logging, name: log, "Detail for account %s", address)
		#endif
		return prepare(endpoints.account(.details, param: [param]), for: AccountResponse.self, log: log)
			.map { response -> Account in
				#if canImport(os)
				os_signpost(.end, log: self.logging, name: log,
							"%d in %s", response.data.balance, response.data.address)
				#endif
				return response.data
		}
		.eraseToAnyPublisher()
	}
	#endif

	// MARK: - Metrics

	#if canImport(Combine)
	/// Get the total number of transactions
	public func totalTransactions() -> AnyPublisher<Int, ErrorAPI> {
		let log : StaticString = "Total Transactions"

		#if canImport(os)
		os_signpost(.begin, log: logging, name: log)
		#endif
		return prepare(endpoints.metrics(.txCount), for: MetricResponse.self, log: log)
			.map { response -> Int in
				#if canImport(os)
				os_signpost(.end, log: self.logging, name: log, "%d transaction", response.data)
				#endif
				return response.data
		}
		.eraseToAnyPublisher()
	}
	#endif

	#if canImport(Combine)
	/// Get the total number of block
	public func totalBlocks() -> AnyPublisher<Int, ErrorAPI> {
		let log : StaticString = "Total Blocks"

		#if canImport(os)
		os_signpost(.begin, log: logging, name: log)
		#endif
		return prepare(endpoints.metrics(.blockCount), for: MetricResponse.self, log: log)
			.map { response -> Int in
				#if canImport(os)
				os_signpost(.end, log: self.logging, name: log, "%d blocks", response.data)
				#endif
				return response.data
		}
		.eraseToAnyPublisher()
	}
	#endif

	#if canImport(Combine)
	/// Get the total number of accounts
	public func totalAccounts() -> AnyPublisher<Int, ErrorAPI> {
		let log : StaticString = "Total Accounts"

		#if canImport(os)
		os_signpost(.begin, log: logging, name: log)
		#endif
		return prepare(endpoints.metrics(.accountCount), for: MetricResponse.self, log: log)
			.map { response -> Int in
				#if canImport(os)
				os_signpost(.end, log: self.logging, name: log, "%d accounts", response.data)
				#endif
				return response.data
		}
		.eraseToAnyPublisher()
	}
	#endif

	#if canImport(Combine)
	/// Get the total number of contracts
	public func totalContracts() -> AnyPublisher<Int, ErrorAPI> {
		let log : StaticString = "Total Contracts"

		#if canImport(os)
		os_signpost(.begin, log: logging, name: log)
		#endif
		return prepare(endpoints.metrics(.contractCount), for: MetricResponse.self, log: log)
			.map { response -> Int in
				#if canImport(os)
				os_signpost(.end, log: self.logging, name: log, "%d contracts", response.data)
				#endif
				return response.data
		}
		.eraseToAnyPublisher()
	}
	#endif
}
