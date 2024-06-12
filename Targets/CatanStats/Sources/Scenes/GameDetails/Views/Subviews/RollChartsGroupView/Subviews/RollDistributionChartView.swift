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
		return counter.diceModel.rollResult.description
	}

	private func getRollCount() -> Int {
		counterModel.counters.reduce(0) { $0 + $1.count }
	}

	private func expectedCount(rollsCount: Int, _ counter: RollModelCounter) -> Double {
		let diceModel = counter.diceModel
		switch diceModel.rollResult {
		case .number(let rollValue):
			return Double(rollsCount) * DiceModel.probability(for: .number(rollValue))
		case .castleShip(let castleShipResult):
			return Double(rollsCount) * DiceModel.probability(for: .castleShip(castleShipResult))
		}
	}
}

#Preview {
	RollDistributionChartView(counterModel:
		ChartCountersModel(counters:
				(2...12).map { number in
					let randomCount = Int.random(in: 2...10)
					return RollModelCounter(diceModel: DiceModel(rollResult: .number(number)), count: randomCount)
				}
		)
	)
}
