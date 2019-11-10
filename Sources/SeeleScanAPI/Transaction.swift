//
//  Transaction.swift
//  SeeleScanAPI
//
//  Created by Marcus Florentin on 10/11/2019.
//

import Foundation

public struct Transaction: Codable, Identifiable {

	public let txtype : Int

	public let shardnumber : Int

	public let txHash : String

	public let block : Int

	public let age : String

	public let from : String

	public let to : String

	public let value : Int

	public let pending : Bool

	public let fee : Int

	public let accountNonce : String

	public let payload : String

	// MARK: Identifiable

	public var id : String {
		txHash
	}

}
