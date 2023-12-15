//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Denis Abramov on 05.11.2023.
//

import UIKit
import CoreData

protocol WeatherViewModelProtocol {
    func updateView()
    func failedToFetchWeather(error: String)
}

class WeatherViewModel {
    let service = WeatherService()
    var weather = [CurrentWeather]()

    private var view: WeatherViewModelProtocol?

    func attachView(view: WeatherViewModelProtocol) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }
    
    func getWeatherForCity(city: String) {
        
        service.getWeatherForCity(city: city, completion: { result in
            switch(result){
            case .success(let weather):
                self.weather.append(weather)

                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else { return }
                let savedLocation = Location.init(context: appDelegate.persistentContainer.viewContext)
                savedLocation.locationId = Int64(weather.id ?? 0)
                savedLocation.locationName = weather.name
                appDelegate.saveContext()
                self.view?.updateView()
               break
            case .failure(let error):
                self.view?.failedToFetchWeather(error: error.localizedDescription)
                break
            }
        })
    }
    
    func checkIfCityExists(city: String, completion: @escaping (Bool) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "locationName ==[c] %@", city)
        
        do {
             let count = try context.count(for: fetchRequest)
             completion(count > 0)
        } catch {
             completion(false)
        }
    }
    
    func getWeatherForSavedLocations() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let request: NSFetchRequest<Location> = Location.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let savedLocations = try context.fetch(request)
        
            if savedLocations.count > 0 {
                var locationIds = [String]()
            
                for location in savedLocations {
                    locationIds.append(String(location.locationId))
                }

                service.getWeatherForCities(cityList: locationIds) { result in
                    
                    switch (result) {
                    case .success(let weatherList):
                    
                        guard let weatherList = weatherList.list else { return }
                        
                        for weather in weatherList {
                            self.weather.append(weather)
                        }
                        self.view?.updateView()
                    case .failure(let error):
                        self.view?.failedToFetchWeather(error: error.localizedDescription)
                    }
                }
            }
        } catch {
            print("Unexpected exception while fetching data : \(error)")
        }
    }
    
    func deleteLocation(city: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "locationId == %@", city)
        
        do {
            let locations = try context.fetch(fetchRequest)
            
            guard let location = locations.first else { return }
            
            context.delete(location)
            
            try context.save()
        } catch {
            print("Ошибка при удалении объекта из CoreData: \(error)")
        }
    }
    
    func deleteWeatherForCity(at indexPath: IndexPath) {
          let weather = self.weather[indexPath.row]
          self.weather.remove(at: indexPath.row)
          
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
          
          let context = appDelegate.persistentContainer.viewContext
          let request: NSFetchRequest<Location> = Location.fetchRequest()
          request.predicate = NSPredicate(format: "locationId == %d", Int64(weather.id ?? 0))
          
          do {
              let savedLocations = try context.fetch(request)
              
              if let savedLocation = savedLocations.first {
                  context.delete(savedLocation)
              }
              
              try context.save()
          } catch {
              print("Unexpected exception while deleting data : \(error)")
          }
      }
  }
