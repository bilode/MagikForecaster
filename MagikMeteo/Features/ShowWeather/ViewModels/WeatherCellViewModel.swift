//
//  WeatherCellViewModel.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 03/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation

class WeatherCellViewModel {

    var stringDate: String

    init(withDate date:Date?) {

        self.stringDate = WeatherCellViewModel.stringForDate(date)
    }

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d MMMM yyyy H' h 'mm"
        return formatter
    }()


    private static func stringForDate(_ date: Date?) -> String {

        return date != nil ? WeatherCellViewModel.formatter.string(from: date!) : "unknown date"
    }
}
