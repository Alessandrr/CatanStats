//
//  ValidationErrors.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 06.07.24.
//

import Foundation

enum ValidationError {
	case emptyPlayerName(index: Int)
}

struct ValidationErrors: Error {
	let validationErrors: [ValidationError]

	func hasError(forPlayerAtIndex index: Int) -> Bool {
		return validationErrors.contains { error in
			if case .emptyPlayerName(let errorIndex) = error {
				return errorIndex == index
			}
			return false
		}
	}
}
