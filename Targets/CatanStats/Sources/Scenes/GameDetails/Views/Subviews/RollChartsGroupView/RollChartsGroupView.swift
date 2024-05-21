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
