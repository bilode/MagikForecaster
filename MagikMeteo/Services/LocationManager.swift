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

    private let creationDate: Date

    static let shared = LocationManager()
    override private init() { self.creationDate = Date() }

    var locationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()

    var handler: ((Result<CLLocation, Error>) -> Void)?

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

                self.handler?(.failure(LocationManagerError.invalidData))
                return
        }

        self.handler?(.success(lastLocation))
    }


    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.handler?(.failure(error))
    }
}
