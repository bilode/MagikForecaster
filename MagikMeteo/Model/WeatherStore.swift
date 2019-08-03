//
//  WeatherStore.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation

class WeatherStore: Decodable {

    var entries: [Date: Weather]

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

        self.entries = container.allKeys.reduce([:], { (result, key) -> [Date: Weather] in
            var result = result
            if let weather = try? container.decodeIfPresent(Weather.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!),
                let inputDate = WeatherStore.formatter.date(from: key.stringValue) {
                result[inputDate] = weather
            }
            return result
        })
    }
}
