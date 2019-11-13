//
//  Responses.swift
//  SeeleScanAPI
//
//  Created by Marcus Florentin on 27/09/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

protocol ResponseAPI: Codable {

	var code : Int { get }

	associatedtype ResponseData = Codable

	var data : ResponseData { get }

	var message : String { get }
}

// MARK: List

public protocol PageInfo: Codable {

	var begin : Int { get }

	var curPage : Int { get }

	var end :  Int { get }

	var totalCount : Int { get }
}

public struct Page: PageInfo {

	public let begin: Int

	public let curPage: Int

	public let end: Int

	public let totalCount: Int
}

protocol ResponseList: Codable {

	associatedtype ResponseData = Codable
	var list : [ResponseData] { get }

	associatedtype Info = PageInfo
	var pageInfo : Info { get }
}


// MARK: - Node

struct NodeList: ResponseList {

	let list: [Node]

	var pageInfo: Page
}

struct NodesResponse: ResponseAPI {

	let code: Int

	let data: NodeList

	let message: String
}

struct NodeResponse: ResponseAPI {

	let code: Int

	let data: Node

	let message: String
}

struct NodeMapResponse: ResponseAPI {

	let code: Int

	let data: [Node]

	let message: String
}

// MARK: - Account

public struct AccountPage: PageInfo {

	public let begin: Int

	public let curPage: Int

	public let end: Int

	public let totalBalance : Int

	public var totalCount: Int
}

struct AccountList: ResponseList {

	let list: [Account]

	let pageInfo: AccountPage
}

struct AccountsResponse: ResponseAPI {

	let code: Int

	let data: AccountList

	let message: String
}

struct AccountResponse: ResponseAPI {

	let code: Int

	let data: Account

	let message: String
}

// MARK: - Metrics

struct MetricResponse : ResponseAPI {

	/// Error code, 0 is normal, non-zero is wrong
	let code: Int

	/// Total number
	let data: Int

	/// Errors, correct implementation of the empty
	let message: String
}
