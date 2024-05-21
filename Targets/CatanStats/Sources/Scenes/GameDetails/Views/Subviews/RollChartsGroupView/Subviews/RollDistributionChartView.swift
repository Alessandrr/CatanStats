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
						expectedCount(rollsCount: getRollCount(), counter)
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
		guard let diceModel = counter.diceModel as? (any Probabilistic) else { return "" }
		return diceModel.rollResult.description
	}

	private func getRollCount() -> Int {
		counterModel.counters.reduce(0) { $0 + $1.count }
	}

	private func expectedCount(rollsCount: Int, _ counter: RollModelCounter) -> Double {
		let diceModel = counter.diceModel
		switch diceModel {
		case let diceModel as NumberDiceModel:
			return Double(rollsCount) * diceModel.probability(for: diceModel.rollResult)
		case let diceModel as ShipAndCastlesDiceModel:
			return Double(rollsCount) * diceModel.probability(for: diceModel.rollResult)
		default:
			return 0
		}
	}
}

#Preview {
	RollDistributionChartView(counterModel:
		ChartCountersModel(counters:
			[
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 2), count: 2),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 3), count: 3),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 4), count: 4),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 5), count: 5),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 6), count: 6),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 7), count: 7),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 8), count: 5),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 9), count: 5),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 10), count: 3),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 11), count: 1),
				RollModelCounter(diceModel: NumberDiceModel(rollResult: 12), count: 1)
			]
		)
	)
}
