//
//  WeatherViewModel.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation

class WeatherListViewModel {

    private var weatherStore: WeatherStore
    var minNumberOfVisibleElements: Int

    init(withStore store: WeatherStore) {

        self.minNumberOfVisibleElements = 5
        self.weatherStore = store
    }

    var numberOfElements: Int {
        return self.weatherStore.allEntries.count
    }

    func viewModelForElement(withIndex index: Int) -> WeatherCellViewModel {
        return WeatherCellViewModel(withDate: weatherStore.allEntries[index].date)
    }
}

