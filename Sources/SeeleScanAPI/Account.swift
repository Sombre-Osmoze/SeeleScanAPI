//
//  Account.swift
//  SeeleScanAPI
//
//  Created by Marcus Florentin on 10/11/2019.
//

import Foundation

public struct Account: Codable, Identifiable {


	public let address : String

	public let balance : Int

	public let percentage : Double

	public let txcount : Int

	public let txs : [Transaction]?

	// MARK: Identifiable

	public var id: String {
		address
	}
}
