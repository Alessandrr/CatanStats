//
//  GameDetailsViewData.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 18.05.24.
//

import Foundation

struct GameDetailsViewData {
	var navigationTitle: String
	var tableViewCounters: [RollSection: [RollModelCounter]]
	var chartViewCounters: [RollModelCounter]
}
