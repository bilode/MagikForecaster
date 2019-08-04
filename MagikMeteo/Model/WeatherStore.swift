//
//  WeatherStore.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation

struct Const {
    static let storeFileName = "store.json"
}

class WeatherStore: Decodable, Equatable {


    var allEntries: [Weather]

    private struct CustomCodingKeys: CodingKey {
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }

        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
    }


    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()


    /*****************************************************************************/
    // MARK: - Initializers

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)

        self.allEntries = container.allKeys.reduce([], { (result, key) -> [Weather] in

            var result = result
            if var weather = try? container.decodeIfPresent(Weather.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!),
                let inputDate = WeatherStore.formatter.date(from: key.stringValue) {
                weather.date = inputDate
                result.append(weather)
                return result
            }
            return result
        })

        self.sortEntries()
    }


    init() {
        self.allEntries = []
    }


    private func sortEntries() {
        self.allEntries.sort { (leftElmt, rightElmt) -> Bool in

            if let leftDate = leftElmt.date,
                let rightDate = rightElmt.date {
                return leftDate < rightDate
            }

            return rightElmt.date != nil
        }
    }

    /*****************************************************************************/
    // MARK: - Services

    static func loadFromService(lat: String, lon: String, completion: @escaping (Result<WeatherStore, Error>) -> Void) {

        WSManager.shared.fetchWeather(lat: lat, lon: lon) { result in
            completion(result)
        }
    }

    /*****************************************************************************/
    // MARK: - Persistence management

    var storeFileName: String {
        get {
            return Const.storeFileName
        }
    }

    func saveToDisk() throws {
        let jsonData = try JSONEncoder().encode(self.allEntries)

        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.storeFileName)

        try jsonData.write(to: fileURL, options: .atomic)
    }


    func loadFromDisk() throws {
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.storeFileName)

        let data = try Data(contentsOf: fileURL)

        self.allEntries = try JSONDecoder().decode([Weather].self, from: data)

        self.sortEntries()
    }


    /*****************************************************************************/
    // MARK: - Equatable

    static func == (lhs: WeatherStore, rhs: WeatherStore) -> Bool {
        return lhs.allEntries == rhs.allEntries
    }
}
