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

@available(OSX 10.15, iOS 13.0, watchOS 6.0, *)
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
