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
			ForEach(viewModel.displayItems, id: \.self) { displayItem in
				BarMark(
					x: .value("Roll", displayItem.description),
					y: .value("Count", displayItem.count)
				)
				.foregroundStyle(by: .value("Player", displayItem.playerName))
//				RuleMark(
//					xStart: .value("Roll", getRollDescriptionFromModel(diceModel)),
//					xEnd: .value("Roll", getRollDescriptionFromModel(diceModel)),
//					y: .value(
//						"Expected count",
//						expectedCount(rollsCount: getRollCount(), diceModel)
//					)
//				)
//				.foregroundStyle(.purple)
//				.lineStyle(.init(lineWidth: 3))
			}
		}
		.padding()
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
		RollChartViewModel(
			displayItems: [
				ChartRollDisplayItem(playerName: "One", description: "2", count: 2),
				ChartRollDisplayItem(playerName: "Two", description: "2", count: 2)
			]
		)
	)
}
