//
//  Transaction.swift
//  SeeleScanAPI
//
//  Created by Marcus Florentin on 10/11/2019.
//

import Foundation

public struct TransactionPreview: Codable, Identifiable {

	public let shardnumber : Int

	public let txtype : Int

	public let hash : String

	public let block : Int

	public let from : String

	public let to : String

	public let value : Int

	public let age : String

	public let fee : Int

	public let inorout : Bool

	public let pending : Bool

	// MARK: Identifiable

	public var id : String {
		hash
	}

}
