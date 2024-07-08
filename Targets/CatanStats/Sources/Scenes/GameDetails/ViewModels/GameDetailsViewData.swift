//
//  GameDetailsViewData.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 18.05.24.
//

import Foundation

struct GameDetailsViewData {
	var tableDisplayItems: [RollSection: [TableRollDisplayItem]]
	var chartRollDisplayItems: [RollSection: [ChartRollDisplayItem]]
	var chartExpectedDisplayItems: [RollSection: [ExpectedCountDisplayItem]]
}
