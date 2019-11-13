//
//  Node.swift
//  SeeleScanAPI
//
//  Created by Marcus Florentin on 13/11/2019.
//

import Foundation

public struct Node: Codable, Identifiable {

	public let id : String

	public let shard : Int

	public let host : String
	public let port : String

	public let city : String
	public let region : String
	public let country : String

	public let client : String

	public let caps : String

	public let lastSeen: Int

	public let coordinate: String

	enum CodingKeys: String, CodingKey {
		case shard = "ShardNumber"
		case id = "ID"
		case host = "Host"
		case port = "Port"
		case city = "City"
		case region = "Region"
		case country = "Country"
		case client = "Client"
		case caps = "Caps"
		case lastSeen = "LastSeen"
		case coordinate = "LongitudeAndLatitude"
	}
}
