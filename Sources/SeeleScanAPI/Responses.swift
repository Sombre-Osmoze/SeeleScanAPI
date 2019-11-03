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

// MARK: - Metrics

public struct MetricResponse : ResponseAPI {

	/// Error code, 0 is normal, non-zero is wrong
	public let code: Int

	/// Total number
	public let data: Int

	/// Errors, correct implementation of the empty
	public let message: String
}
