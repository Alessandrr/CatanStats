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
					displayItems: viewModel.rollDisplayItems[.numberRolls] ?? [],
					expectedCountDisplayItems: viewModel.expectedCountDisplayItems[.numberRolls] ?? []
				)
			)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.Padding.large, trailing: 0))

			RollDistributionChartView(
				viewModel: RollChartViewModel(
					displayItems: viewModel.rollDisplayItems[.shipAndCastles] ?? [],
					expectedCountDisplayItems: viewModel.expectedCountDisplayItems[.shipAndCastles] ?? []
				)
			)
			.padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.Padding.large, trailing: 0))
		}
		.tabViewStyle(.page(indexDisplayMode: .always))
		.indexViewStyle(.page(backgroundDisplayMode: .always))
	}
}
