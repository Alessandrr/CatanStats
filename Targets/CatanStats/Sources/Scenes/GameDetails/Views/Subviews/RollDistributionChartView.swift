//
//  RollDistributionChartView.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 28.04.24.
//

import SwiftUI
import Charts

struct RollDistributionChartView: View {
	@ObservedObject var counterModel: ChartCountersModel

	var body: some View {
		Chart {
			ForEach(counterModel.counters, id: \.self) { counter in
				BarMark(
					x: .value("Roll", getRollDescriptionFromCounter(counter)),
					y: .value("Count", counter.count)
				)
				RuleMark(
					xStart: .value("Roll", getRollDescriptionFromCounter(counter)),
					xEnd: .value("Roll", getRollDescriptionFromCounter(counter)),
					y: .value(
						"Expected count",
						expectedCount(
							rollsCount: getRollCount(),
							result: getRollValueFromCounter(counter)
						)
					)
				)
				.foregroundStyle(.purple)
				.lineStyle(.init(lineWidth: 3))
			}
		}
		.chartForegroundStyleScale([
			CatanStatsStrings.GameDetails.expectedCount: .purple,
			CatanStatsStrings.GameDetails.actualCount: .blue
		])
		.padding()
	}

	private func getRollDescriptionFromCounter(_ counter: RollModelCounter) -> String {
		guard case let RollModel.number(rollResult) = counter.rollModel else {
			return ""
		}
		return rollResult.description
	}

	private func getRollValueFromCounter(_ counter: RollModelCounter) -> Int {
		guard case let RollModel.number(rollResult) = counter.rollModel else {
			return 0
		}
		return rollResult
	}

	private func getRollCount() -> Int {
		counterModel.counters.reduce(0) { $0 + $1.count }
	}

	private func expectedCount(rollsCount: Int, result: Int) -> Double {
		let probabilities: [Int: Double] = [
			2: 1/36.0,
			3: 2/36.0,
			4: 3/36.0,
			5: 4/36.0,
			6: 5/36.0,
			7: 6/36.0,
			8: 5/36.0,
			9: 4/36.0,
			10: 3/36.0,
			11: 2/36.0,
			12: 1/36.0
		]

		if let probability = probabilities[result] {
			return Double(rollsCount) * probability
		} else {
			return 0
		}
	}
}

#Preview {
	RollDistributionChartView(counterModel:
		ChartCountersModel(counters:
			[
				RollModelCounter(rollModel: .number(rollResult: 2), count: 2),
				RollModelCounter(rollModel: .number(rollResult: 3), count: 3),
				RollModelCounter(rollModel: .number(rollResult: 4), count: 4),
				RollModelCounter(rollModel: .number(rollResult: 5), count: 5),
				RollModelCounter(rollModel: .number(rollResult: 6), count: 6),
				RollModelCounter(rollModel: .number(rollResult: 7), count: 7),
				RollModelCounter(rollModel: .number(rollResult: 8), count: 5),
				RollModelCounter(rollModel: .number(rollResult: 9), count: 5),
				RollModelCounter(rollModel: .number(rollResult: 10), count: 3),
				RollModelCounter(rollModel: .number(rollResult: 11), count: 2),
				RollModelCounter(rollModel: .number(rollResult: 12), count: 1)
			]
		)
	)
}
