//
//  CurrentWeatherList.swift
//  WeatherApp
//
//  Created by Denis Abramov on 28.11.2023.
//

import Foundation

struct CurrentWeatherList: Codable, Hashable {
    let list: [CurrentWeather]?
}
