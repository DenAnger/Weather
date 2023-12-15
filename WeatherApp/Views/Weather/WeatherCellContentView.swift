//
//  WeatherCellContentView.swift
//  WeatherApp
//
//  Created by Denis Abramov on 01.12.2023.
//

import UIKit

final class WeatherCellContentView: UIView {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    private var cityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private var mainTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private var feelsLikeTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var weatherDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var weather: CurrentWeather?

    private var currentConfiguration: WeatherCellContentConfiguration!
    
    init(configuration: WeatherCellContentConfiguration) {
        super.init(frame: .zero)
        
        
        if let iconPath = self.weather?.weather?.first?.icon {
            let urlString = "https://openweathermap.org/img/wn/\(iconPath).png"
            if let url = URL(string: urlString) {
                weatherIcon.loadImage(from: url)
            }
        }

        
        apply(configuration: configuration)
        self.currentConfiguration = configuration
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func apply(configuration: WeatherCellContentConfiguration) {
        
        guard currentConfiguration != configuration else {
            return
        }

        currentConfiguration = configuration

        cityName.text = configuration.weather?.locationName
        mainTemperature.text = configuration.weather?.currentTemperature
        weatherDescription.text = configuration.weather?.weatherDescription
        feelsLikeTemperature.text = configuration.weather?.feelsLikeTemperature
        weatherIcon.image = configuration.weather?.weatherIcon
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(cityName)
        containerView.addSubview(mainTemperature)
        containerView.addSubview(feelsLikeTemperature)
        containerView.addSubview(weatherDescription)
        containerView.addSubview(weatherIcon)
    }
    
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cityName.topAnchor.constraint(equalTo: containerView.topAnchor, 
                                          constant: 5),
            cityName.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            weatherIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            weatherIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
//            weatherIcon.widthAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8),
            weatherIcon.widthAnchor.constraint(equalToConstant: 50),
            weatherIcon.heightAnchor.constraint(equalTo: weatherIcon.widthAnchor),

            weatherDescription.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 5),
            weatherDescription.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            weatherDescription.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            
            mainTemperature.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 5),
            mainTemperature.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            mainTemperature.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
//            mainTemperature.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
       
            feelsLikeTemperature.topAnchor.constraint(equalTo: mainTemperature.bottomAnchor, constant: 5),
            feelsLikeTemperature.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            feelsLikeTemperature.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
//            feelsLikeTemperature.topAnchor.constraint(equalTo: mainTemperature.bottomAnchor, constant: -5)
        ])
    }
}

extension WeatherCellContentView: UIContentView {
    
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        
        set {
            guard let newConfiguration = newValue as? WeatherCellContentConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
}
