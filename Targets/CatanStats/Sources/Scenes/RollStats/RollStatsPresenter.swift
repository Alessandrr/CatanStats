//
//  RollStatsPresenter.swift
//  CatanStats
//
//  Created by Александр Мамлыго on /74/2567 BE.
//  Copyright © 2567 BE tuist.io. All rights reserved.
//

import Foundation

protocol IRollStatsPresenter {
	func didSelectRollItem(_ item: RollStatsModel)
}

class RollStatsPresenter: IRollStatsPresenter {
	func didSelectRollItem(_ item: RollStatsModel) {
	}
}
