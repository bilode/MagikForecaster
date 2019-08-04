//
//  WeatherDetailViewModel.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation

class WeatherDetailViewModel {

    var weatherEntry: Weather

    init(withWeatherEntry weatherEntry: Weather) {
        self.weatherEntry = weatherEntry
    }
}
