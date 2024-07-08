//
//  RollChartViewModel.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 28.04.24.
//

import Foundation

final class RollChartGroupViewModel: ObservableObject {
	@Published var rollDisplayItems: [RollSection: [ChartRollDisplayItem]]
	@Published var expectedCountDisplayItems: [RollSection: [ExpectedCountDisplayItem]]

	init(
		displayItems: [RollSection: [ChartRollDisplayItem]] = [:],
		expectedCountDisplayItems: [RollSection: [ExpectedCountDisplayItem]] = [:]
	) {
		self.rollDisplayItems = displayItems
		self.expectedCountDisplayItems = expectedCountDisplayItems
	}
}

final class RollChartViewModel: ObservableObject {
	@Published var rollDisplayItems: [ChartRollDisplayItem]
	@Published var expectedCountDisplayItems: [ExpectedCountDisplayItem]

	init(
		displayItems: [ChartRollDisplayItem] = [],
		expectedCountDisplayItems: [ExpectedCountDisplayItem] = []
	) {
		self.rollDisplayItems = displayItems
		self.expectedCountDisplayItems = expectedCountDisplayItems
	}
}
