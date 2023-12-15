//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Denis Abramov on 28.11.2023.
//

import UIKit

struct CurrentWeather: Codable, Hashable {
    let coordinate: Coordinate?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let cloud: Cloud?
    let dataTimeCalculation: Int?
    let system: System?
    let timezone: Int?
    let id: Int?
    let name: String?
    let parameter: Int?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather = "weather"
        case base = "base"
        case main = "main"
        case visibility = "visibility"
        case wind = "wind"
        case cloud = "clouds"
        case dataTimeCalculation = "dt"
        case system = "sys"
        case timezone = "timezone"
        case id = "id"
        case name = "name"
        case parameter = "cod"
        case message = "message"
    }
    
    var locationName: String? {
        return "\(self.name ?? "" ), \(self.system?.country ?? "")"
    }
    
    var currentTemperature: String? {
        return "\(self.main?.temperature ?? 0)°C"
    }
        
    var weatherIcon: UIImage? {
        
        if let iconPath = self.weather?.first?.icon {
            let urlString = "https://openweathermap.org/img/wn/\(iconPath).png"
           
            if let url = URL(string: urlString) {
                return UIImage(url: url)
            }
        }
        return nil
    }
    
    var weatherDescription: String? {
        return "\(self.weather?.first?.description?.capitalized ?? "")"
    }
    
    var feelsLikeTemperature: String? {
        return "Feels Like \(self.main?.feelsLike ?? 0)°C"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = try values.decodeIfPresent(Coordinate.self,
                                                forKey: .coordinate)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        base = try values.decodeIfPresent(String.self, forKey: .base)
        main = try values.decodeIfPresent(Main.self, forKey: .main)
        visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
        wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
        cloud = try values.decodeIfPresent(Cloud.self, forKey: .cloud)
        
        dataTimeCalculation = try values.decodeIfPresent(
            Int.self,
            forKey: .dataTimeCalculation
        )
        
        system = try values.decodeIfPresent(System.self, forKey: .system)
        timezone = try values.decodeIfPresent(Int.self, forKey: .timezone)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        parameter = try values.decodeIfPresent(Int.self, forKey: .parameter)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
    static func == (lhs: CurrentWeather, rhs: CurrentWeather) -> Bool {
        return lhs.id ==  rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
