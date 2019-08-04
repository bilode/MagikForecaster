//
//  WeatherViewModel.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation

class WeatherListViewModel {

    var weatherStore: Dynamic<WeatherStore?>

    var loadingMessage: Dynamic<String>
    var errorMessage: Dynamic<String>

    var minNumberOfVisibleElements: Int

    init() {

        self.minNumberOfVisibleElements = 5
        self.weatherStore = Dynamic(nil)
        self.loadingMessage = Dynamic("")
        self.errorMessage = Dynamic("")
    }


    func viewModelForElement(withIndex index: Int) -> WeatherCellViewModel {
        return WeatherCellViewModel(withDate: weatherStore.value?.allEntries[index].date)
    }


    var numberOfElements: Int {
        return self.weatherStore.value?.allEntries.count ?? 0
    }


    /*****************************************************************************/
    // MARK: - View events

    func viewIsReady() {
        self.loadData()
    }


    /*****************************************************************************/
    // MARK: - Private

    private func loadData() {

        self.setLoadingMessage("Finding your position...")
        LocationManager.shared.requestCurrentLocation { locationResult in
            switch locationResult {
            case .success(let location):
                self.setLoadingMessage("Requesting data from server...")
                WeatherStore.loadFromService(lat: String(location.coordinate.latitude), lon: String(location.coordinate.longitude), completion: { storeResult in
                    switch storeResult {
                    case .success(let store):
                        self.weatherStore.value = store
                        self.finishLoading()
                    case .failure(let serviceError):
                        self.handleServiceFailure(serviceError)
                    }
                })
            case .failure(let locationError):
                self.handleServiceFailure(locationError)
            }
        }
    }


    private func handleServiceFailure(_ error: Error) {
        print(error.localizedDescription)

        do {
            let store = WeatherStore()
            try store.loadFromDisk()
            self.weatherStore.value = store
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

