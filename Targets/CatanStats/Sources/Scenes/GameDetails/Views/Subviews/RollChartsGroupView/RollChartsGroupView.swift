//
//  RollChartsGroupView.swift
//  CatanStats
//
//  Created by Aleksandr Mamlygo on 20.05.24.
//

import SwiftUI

struct RollChartsGroupView: View {
	@ObservedObject var viewModel: RollChartGroupViewModel

	var body: some View {
		TabView {
			RollDistributionChartView(
				viewModel: RollChartViewModel(
					displayItems: viewModel.displayItems[.numberRolls] ?? []
				)
			)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.Padding.large, trailing: 0))

			RollDistributionChartView(
				viewModel: RollChartViewModel(
					displayItems: viewModel.displayItems[.shipAndCastles] ?? []
				)
			)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.Padding.large, trailing: 0))
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
		.indexViewStyle(.page(backgroundDisplayMode: .always))
	}
}

//#Preview {
//	RollChartsGroupView(
//		viewModel: RollChartViewModel(
//			models:
//				(2...12).map { number in
//					let randomCount = Int.random(in: 2...10)
//					return DiceModel(rollResult: .number(number), counter: randomCount)
//				}
//		)
//	)
//}
