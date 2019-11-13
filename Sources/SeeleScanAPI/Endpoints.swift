//
//  Endpoints.swift
//  SeeleScanAPI
//
//  Created by Marcus Florentin on 27/09/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

public struct Endpoints {

	private let domain = URL(string: "https://api.seelescan.net/")!

	enum Version: String {
		case v1 = "v1"
	}

	let version : Version = .v1

	private func main() -> URL {
		URL(string: "/api/\(version.rawValue)/", relativeTo: domain)!
	}

	// MARK: Node

	func node(_ route: Routes.Node, param: Set<URLQueryItem>? = nil) -> URL {
		var url = main()

		url.appendPathComponent(route.rawValue)

		if let parameters = param {
			var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
			components.queryItems = parameters.sorted(by: { $0.name < $1.name })

			return components.url!
		}

		return url
	}

	// MARK: Account

	func account(_ route: Routes.Account, param: Set<URLQueryItem>? = nil) -> URL {
		var url = main()

		url.appendPathComponent(route.rawValue)

		// If parameters are provided include them in the url query
		if let parameters = param {
			var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

			components.queryItems = parameters.sorted(by: { $0.name < $1.name })

			return components.url!
		}
		return url
	}


	// MARK: Metrics

	/// Stats Metrics API endpoints
	/// - Parameter route: The endpoint required
	/// - Returns: The url for the required endpoint
	func metrics(_ route: Routes.Metrics) -> URL {
		var url = main()

		url.appendPathComponent(route.rawValue)

		return url
	}

}


// MARK: - Routes

enum Routes {

	enum Node: String {
		case list = "nodes"
		case details = "node"
		case map = "nodemap"
	}

	enum Account: String {
		case list = "accounts"
		case details = "account"
	}

	enum Metrics: String {
		case txCount = "txcount"
		case blockCount = "blockcount"
		case accountCount = "accountcount"
		case contractCount = "contractcount"
	}

}


// MARK: - URL Parameters

extension URLQueryItem {

	/// Create a url query item for the correct shard.
	/// - Parameter shard: The shardNumber
	init(shard: Int) {
		self = .init(name: "s", value: shard.description)
	}

	// MARK: Node

	init(id: String) {
		self = .init(name: "id", value: id)
	}

	// MARK: Account

	/// Create a url query item for a account
	/// - Parameter address: Account address
	init(address: String) {
		self = .init(name: "address", value: address)
	}

	// MARK:  Page

	/// Create a url query item for a page
	/// - Parameter index: The page number to display
	init(page index: Int) {
		self = .init(name: "p", value: index.description)
	}

	/// Create a url query item for the page size
	/// - Parameter size: The number of pages displayed
	init(size: Int) {
		self = .init(name: "ps", value: size.description)
	}

}
