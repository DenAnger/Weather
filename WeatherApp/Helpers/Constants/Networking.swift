//
//  Networking.swift
//  WeatherApp
//
//  Created by Denis Abramov on 28.11.2023.
//

import Foundation

struct Networking {
    struct Domain {
        static let production = "https://api.openweathermap.org/data/2.5/"
        
        struct Path {
            static let weather = "weather"
            static let group = "group"
        }
    }
}
