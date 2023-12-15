//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Denis Abramov on 05.11.2023.
//

import Foundation
import CoreData

protocol WeatherServiceProtocol {

    var baseUrlString: String { get }

    func getWeatherForCity(city: String,
                           completion: @escaping((Result<CurrentWeather,
                                                  NetworkError>) -> Void))
    
    func getWeatherForCities(cityList: [String]?,
                             completion: @escaping((Result<CurrentWeatherList,
                                                    NetworkError>) -> Void))
}

class WeatherService: WeatherServiceProtocol {
    let networkManager = NetworkManager(client: NetworkClient())
    
    var baseUrlString: String {
        return Networking.Domain.production
    }

    func getWeatherForCity(city: String,
                           completion: @escaping((Result<CurrentWeather,
                                                  NetworkError>) -> Void)) {
        
        let serviceString = "\(baseUrlString)/\(Networking.Domain.Path.weather)"
        let queryParameters = ["q": city,
                               "appid": Constant.apiKey,
                               "units": "metric"]
        
        guard let urlRequest = HTTPRequestHandler().createRequest(
            serviceString,
            parameters: queryParameters,
            headers: [:]
        ) else {
            return
        }
        
        networkManager.fetch(with: urlRequest,
                             decodingType: CurrentWeather.self) { (result) in
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func getWeatherForCities(cityList: [String]?,
                             completion: @escaping((Result<CurrentWeatherList,
                                                    NetworkError>) -> Void)) {
        let webServiceUrlString = "\(baseUrlString)/\(Networking.Domain.Path.group)"
        
        guard let cityList = cityList else { return }
        
        let idString = cityList.joined(separator:",")
        let customQueryParameters = ["id": idString,
                                     "appid": Constant.apiKey,
                                     "units": "metric"]
        
        guard let urlRequest = HTTPRequestHandler().createRequest(
            webServiceUrlString,
            parameters: customQueryParameters,
            headers: [:]
        ) else {
            return
        }

        networkManager.fetch(with: urlRequest, 
                             decodingType: CurrentWeatherList.self) { (result) in
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
