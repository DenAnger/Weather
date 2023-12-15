//
//  Main.swift
//  WeatherApp
//
//  Created by Denis Abramov on 28.11.2023.
//

import Foundation

struct Main: Codable, Hashable {
    let temperature: Double?
    let feelsLike: Double?
    let temperatureMinimum: Double?
    let temperatureMaximum: Double?
    let pressure: Int?
    let seaLevel: Int?
    let groundLevel: Int?
    let humidity: Int?
    let uuid: String?

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case temperatureMinimum = "temp_min"
        case temperatureMaximum = "temp_max"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity = "humidity"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temperature = try values.decodeIfPresent(Double.self,
                                                 forKey: .temperature)
        feelsLike = try values.decodeIfPresent(Double.self, forKey: .feelsLike)
        
        temperatureMinimum = try values.decodeIfPresent(
            Double.self,
            forKey: .temperatureMaximum
        )
        temperatureMaximum = try values.decodeIfPresent(
            Double.self,
            forKey: .temperatureMaximum
        )
        
        pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
        seaLevel = try values.decodeIfPresent(Int.self, forKey: .seaLevel)
        groundLevel = try values.decodeIfPresent(Int.self, forKey: .groundLevel)
        humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
        uuid = UUID().uuidString
    }
    
    static func == (lhs: Main, rhs: Main) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
