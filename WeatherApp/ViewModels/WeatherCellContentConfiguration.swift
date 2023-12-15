//
//  WeatherCellContentConfiguration.swift
//  WeatherApp
//
//  Created by Denis Abramov on 01.12.2023.
//

import UIKit

struct WeatherCellContentConfiguration: UIContentConfiguration, Hashable {

    var weather: CurrentWeather?

    func makeContentView() -> UIView & UIContentView {
        return WeatherCellContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> WeatherCellContentConfiguration {
        return self
    }
}
