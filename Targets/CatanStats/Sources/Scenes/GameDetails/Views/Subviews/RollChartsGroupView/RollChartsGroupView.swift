//
//  RollChartsGroupView.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 20.05.24.
//

import SwiftUI

struct RollChartsGroupView: View {
	@ObservedObject var counterModel: ChartCountersModel

	private var numberRollsCounters: [RollModelCounter] {
		counterModel.getCounters(for: .numberRolls)
	}

	private var shipAndCastlesRollsCounters: [RollModelCounter] {
		counterModel.getCounters(for: .shipAndCastles)
	}

	var body: some View {
		TabView {
			RollDistributionChartView(
				counterModel: ChartCountersModel(
					counters: numberRollsCounters
				)
			)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.Padding.large, trailing: 0))

			RollDistributionChartView(
				counterModel: ChartCountersModel(
					counters: shipAndCastlesRollsCounters
				)
			)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.Padding.large, trailing: 0))
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
		.indexViewStyle(.page(backgroundDisplayMode: .always))
	}
}

#Preview {
	RollChartsGroupView(
		counterModel: ChartCountersModel(
			counters:
				(2...12).map { number in
					let randomCount = Int.random(in: 2...10)
					return RollModelCounter(diceModel: DiceModel(rollResult: .number(number)), count: randomCount)
				}
		)
	)
}
