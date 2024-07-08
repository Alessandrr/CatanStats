//
//  BarMark+PlayerNameForegroundStyle.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 06.07.24.
//

import SwiftUI
import Charts

extension BarMark {
	@ChartContentBuilder
	func playerNameForegroundStyle(playerName: String?) -> some ChartContent {
		if let playerName = playerName {
			self.foregroundStyle(by: .value("Player", playerName))
		} else {
			self
		}
	}
}
