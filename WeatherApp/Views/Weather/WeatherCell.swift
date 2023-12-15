//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Denis Abramov on 01.12.2023.
//

import UIKit

final class WeatherCell: UICollectionViewCell {
    
    var currentWeather: CurrentWeather?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = WeatherCellContentConfiguration().updated(for: state)
        newConfiguration.weather = currentWeather
        contentConfiguration = newConfiguration
    }
}
