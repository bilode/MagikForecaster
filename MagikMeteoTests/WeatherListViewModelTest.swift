//
//  WeatherListViewModelTest.swift
//  MagikMeteoTests
//
//  Created by Timothée Bilodeau on 04/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

@testable import MagikMeteo
import XCTest
import CoreLocation

enum mockError: Error {
    case bamboozled
}

class LocationManagerMock: LocationManager {

    override init() { super.init() }

    override func requestCurrentLocation(callback: @escaping (Result<CLLocation, Error>) -> Void) {

        callback(.failure(mockError.bamboozled))
    }
}

class WeatherStoreNoLocalLoad: WeatherStore {

    override func loadFromDisk() throws {

        throw mockError.bamboozled
    }
}


// Unfinished
class WeatherListViewModelTest: XCTestCase {

    func testLoadData() {

        let viewModel = WeatherListViewModel(withLocationManager: LocationManagerMock(), weatherStore: WeatherStoreNoLocalLoad())

        XCTAssert(viewModel.errorMessage.value.isEmpty)

        viewModel.loadData()

        XCTAssertEqual(viewModel.weatherStore.value.allEntries.count, 0)
        XCTAssertFalse(viewModel.errorMessage.value.isEmpty)
        XCTAssert(viewModel.loadingMessage.value.isEmpty)
    }

}
