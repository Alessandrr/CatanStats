//
//  ChartCountersModel.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 28.04.24.
//

import Foundation

final class ChartCountersModel: ObservableObject {
	@Published var counters: [RollModelCounter]

	init(counters: [RollModelCounter] = []) {
		self.counters = counters
	}
}
