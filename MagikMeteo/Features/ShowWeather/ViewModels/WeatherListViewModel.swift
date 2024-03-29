//
//  WeatherViewModel.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation

class WeatherListViewModel {

    var weatherStore: Dynamic<WeatherStore>

    var loadingMessage: Dynamic<String>
    var errorMessage: Dynamic<String>

    var selectedWeather: Dynamic<Weather?>

    var minNumberOfVisibleElements: Int

    var locationManager: LocationManager

    init(withLocationManager locationManager: LocationManager, weatherStore store: WeatherStore) {

        self.minNumberOfVisibleElements = 5
        self.weatherStore = Dynamic(store)
        self.loadingMessage = Dynamic("")
        self.errorMessage = Dynamic("")

        self.selectedWeather = Dynamic(nil)

        self.locationManager = locationManager
    }


    func viewModelForElement(withIndex index: Int) -> WeatherCellViewModel {
        return WeatherCellViewModel(withDate: weatherStore.value.allEntries[index].date)
    }


    var numberOfElements: Int {
        return self.weatherStore.value.allEntries.count
    }


    /*****************************************************************************/
    // MARK: - View events

    func viewIsReady() {
        self.loadData()
    }


    func didSelectRow(atIndex index: Int) {
        guard self.weatherStore.value.allEntries.count > index else {
                return
        }

        self.selectedWeather.value = self.weatherStore.value.allEntries[index]
    }


    /*****************************************************************************/
    // MARK: - Private

    func loadData() {

        self.setLoadingMessage("Finding your position...")
        self.locationManager.requestCurrentLocation { [weak self] locationResult in
            switch locationResult {
            case .success(let location):
                self?.setLoadingMessage("Requesting data from server...")
                WeatherStore.loadFromService(lat: String(location.coordinate.latitude), lon: String(location.coordinate.longitude), completion: { [weak self] storeResult in
                    switch storeResult {
                    case .success(let store):
                        self?.weatherStore.value = store
                        self?.finishLoading()
                    case .failure(let serviceError):
                        self?.handleServiceFailure(serviceError)
                    }
                })
            case .failure(let locationError):
                self?.handleServiceFailure(locationError)
            }
        }
    }


    private func handleServiceFailure(_ error: Error) {
        print("handleServiceFailure: \(error.localizedDescription)")

        do {

            try self.weatherStore.value.loadFromDisk()
            self.finishLoading()
        } catch let error {
            self.finishLoading(withError: error)
        }
    }


    private func finishLoading(withError error: Error? = nil) {

        self.errorMessage.value = error != nil ? error!.localizedDescription : ""
        self.loadingMessage.value = ""
    }

    private func setLoadingMessage(_ message: String) {
        self.loadingMessage.value = message
        self.errorMessage.value = ""
    }
}

