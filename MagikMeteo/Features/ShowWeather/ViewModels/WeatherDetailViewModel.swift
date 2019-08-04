//
//  WeatherDetailViewModel.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation

class WeatherDetailViewModel {

    let weatherEntry: Weather

    let temperature: String
    let temp2m: String
    let tempSol: String

    let pression: String
    let pressionNiveauMer: String

    let risqueNeigeValue: String

    init(fromWeatherEntry weatherEntry: Weather) {
        self.weatherEntry = weatherEntry

        self.temperature = "Temperature"
        self.temp2m = String(format: "2m: %.2f", weatherEntry.temperature._2m)
        self.tempSol = String(format: "sol: %.2f", weatherEntry.temperature.sol)

        self.pression = "Pression"
        self.pressionNiveauMer = "Niveau de la mer: \(weatherEntry.pression.niveauDeLaMer)"

        self.risqueNeigeValue = "Risque de neige: \(weatherEntry.risqueNeige)"
    }
}
