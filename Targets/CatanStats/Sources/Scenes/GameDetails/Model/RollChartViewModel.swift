//
//  RollChartViewModel.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 28.04.24.
//

import Foundation

final class RollChartGroupViewModel: ObservableObject {
	@Published var displayItems: [RollSection: [ChartRollDisplayItem]]

	init(displayItems: [RollSection: [ChartRollDisplayItem]] = [:]) {
		self.displayItems = displayItems
	}
}

final class RollChartViewModel: ObservableObject {
	@Published var displayItems: [ChartRollDisplayItem]

	init(displayItems: [ChartRollDisplayItem] = []) {
		self.displayItems = displayItems
	}
}
