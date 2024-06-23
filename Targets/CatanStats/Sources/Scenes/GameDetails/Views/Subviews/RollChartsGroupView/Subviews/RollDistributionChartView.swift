//
//  RollDistributionChartView.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 28.04.24.
//

import SwiftUI
import Charts

struct RollDistributionChartView: View {
	@ObservedObject var viewModel: RollChartViewModel

	var body: some View {
		Chart {
			ForEach(viewModel.diceModels, id: \.self) { diceModel in
				BarMark(
					x: .value("Roll", getRollDescriptionFromModel(diceModel)),
					y: .value("Count", diceModel.counter)
				)
				RuleMark(
					xStart: .value("Roll", getRollDescriptionFromModel(diceModel)),
					xEnd: .value("Roll", getRollDescriptionFromModel(diceModel)),
					y: .value(
						"Expected count",
						expectedCount(rollsCount: getRollCount(), diceModel)
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

	private func getRollDescriptionFromModel(_ model: DiceModel) -> String {
		return model.rollResult.description
	}

	private func getRollCount() -> Int {
		viewModel.diceModels.reduce(0) { $0 + $1.counter }
	}

	private func expectedCount(rollsCount: Int, _ diceModel: DiceModel) -> Double {
		switch diceModel.rollResult {
		case .number(let rollValue):
			return Double(rollsCount) * DiceModel.probability(for: .number(rollValue))
		case .castleShip(let castleShipResult):
			return Double(rollsCount) * DiceModel.probability(for: .castleShip(castleShipResult))
		}
	}
}

#Preview {
	RollDistributionChartView(viewModel:
		RollChartViewModel(models:
				(2...12).map { value in
					let randomCount = Int.random(in: 2...10)
					return DiceModel(rollResult: .number(value), counter: randomCount)
				}
		)
	)
}
