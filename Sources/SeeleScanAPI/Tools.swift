//
//  Tools.swift
//  SeeleScanAPI
//
//  Created by Marcus Florentin on 27/09/2019.
//  Copyright © 2019 Marcus Florentin. All rights reserved.
//

import Foundation

// MARK: - Codable

let decoder : JSONDecoder = JSONDecoder()

// MARK: - Formatting

// MARK: Number

public let numberShortFormatter : NumberFormatter = {
	let format = NumberFormatter()

	format.allowsFloats = true
	format.formattingContext = .dynamic
	format.locale = .autoupdatingCurrent
	format.numberStyle = .none

	return format
}()
