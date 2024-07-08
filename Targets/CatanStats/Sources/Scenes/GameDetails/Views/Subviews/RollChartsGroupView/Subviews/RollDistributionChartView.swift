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
		VStack {
			Chart {
				ForEach(viewModel.rollDisplayItems, id: \.self) { displayItem in
					BarMark(
						x: .value("Roll", displayItem.description),
						y: .value("Count", displayItem.count)
					)
					.playerNameForegroundStyle(playerName: displayItem.playerName)
				}
				ForEach(viewModel.expectedCountDisplayItems, id: \.self) { displayItem in
					RuleMark(
						xStart: .value("Roll", displayItem.description),
						xEnd: .value("Roll", displayItem.description),
						y: .value("Expected count", displayItem.count)
					)
					.foregroundStyle(.teal)
					.lineStyle(StrokeStyle(lineWidth: 3))
				}
			}
			.padding()
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
