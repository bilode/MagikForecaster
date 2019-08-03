//
//  WeatherStore.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation

class WeatherStore: Decodable {

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


    private func sortEntries() {
        self.allEntries.sort { (leftElmt, rightElmt) -> Bool in

            if let leftDate = leftElmt.date,
                let rightDate = rightElmt.date {
                return leftDate < rightDate
            }

            return rightElmt.date != nil
        }
    }
}
