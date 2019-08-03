//
//  Weather.swift
//  MagikMeteo
//
//  Created by Timothée Bilodeau on 02/08/2019.
//  Copyright © 2019 Timothée Bilodeau. All rights reserved.
//

import Foundation


struct Weather: Decodable {

    let temperature: Temperature
    let pression: Pression
    let risqueNeige: String

    var date: Date?

    private enum CodingKeys: String, CodingKey {
        case temperature
        case pression
        case risqueNeige = "risque_neige"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.temperature = try container.decode(Temperature.self, forKey: .temperature)
        self.pression = try container.decode(Pression.self, forKey: .pression)
        self.risqueNeige = try container.decode(String.self, forKey: .risqueNeige)
    }
}


struct Temperature: Decodable {
    let _2m: Double
    let sol: Double
    let _500hPa: Double
    let _850hPa: Double

    private enum CodingKeys: String, CodingKey {
        case _2m = "2m"
        case sol = "sol"
        case _500hPa = "500hPa"
        case _850hPa = "850hPa"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self._2m = try container.decode(Double.self, forKey: ._2m)
        self.sol = try container.decode(Double.self, forKey: .sol)
        self._500hPa = try container.decode(Double.self, forKey: ._500hPa)
        self._850hPa = try container.decode(Double.self, forKey: ._850hPa)
    }
}

struct Pression: Decodable {
    let niveauDeLaMer: Int

    private enum CodingKeys: String, CodingKey {
        case niveauDeLaMer = "niveau_de_la_mer"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.niveauDeLaMer = try container.decode(Int.self, forKey: .niveauDeLaMer)
    }
}
