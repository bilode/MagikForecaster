//
//  WSManager.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 02/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Alamofire
import Foundation

class WSManager: NSObject {

    public static let shared = WSManager()
    override private init() { }

    func fetchWeather(lat: String, lon: String, completion: @escaping (Swift.Result<WeatherStore, Error>) -> Void ) {

        Alamofire.request(Router.fetch(lat: lat, lon: lon)).responseJSON { (response: DataResponse<Any>) in

            switch response.result {
            case .success:
                do {
                    
                    let weatherStore = try JSONDecoder().decode(WeatherStore.self, from: response.data!)
                    completion(.success(weatherStore))

                } catch let decodeError {
                    completion(.failure(decodeError))
                }
            case .failure(let networkError):
                completion(.failure(networkError))
            }
        }
    }
}
