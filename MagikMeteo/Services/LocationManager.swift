//
//  LocationManager.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 04/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import CoreLocation

enum LocationManagerError: Error {
    case invalidData
}

class LocationManager: NSObject {

    var currentTry = 1
    static let maxNumberOfTries = 2

    private let creationDate: Date

    var handler: ((Result<CLLocation, Error>) -> Void)?

    static let shared = LocationManager()
    override init() {
        
        self.creationDate = Date()

        super.init()

        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }


    var locationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()

    func requestCurrentLocation(callback: @escaping (Result<CLLocation, Error>) -> Void) {

        self.handler = callback

        locationManager.requestLocation()
    }
}


/*****************************************************************************/
// MARK: - CLLocationManagerDelegate

extension LocationManager : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let lastLocation = locations.last,
            lastLocation.timestamp > creationDate else {

                self.handleInvalidData()
                return
        }

        self.currentTry = 0
        self.handler?(.success(lastLocation))
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.handler?(.failure(error))
    }


    // Loop and retry up to 3 times
    private func handleInvalidData() {
        guard let handler = self.handler else { return }

        if self.currentTry > LocationManager.maxNumberOfTries {
            self.handler?(.failure(LocationManagerError.invalidData))
            return
        }

        self.currentTry += 1
        self.requestCurrentLocation(callback: handler)
    }
}
