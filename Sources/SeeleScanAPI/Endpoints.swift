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

	enum Metrics: String {
		case txCount = "txcount"
		case blockCount = "blockcount"
		case accountCount = "accountcount"
		case contractCount = "contractcount"
	}

}
