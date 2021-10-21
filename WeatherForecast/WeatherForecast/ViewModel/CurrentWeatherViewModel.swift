//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by Soll on 2021/10/13.
//

import UIKit

class CurrentWeatherViewModel {
    
    var reloadTableView: (() -> Void)?
    
    var administrativeArea: String = "서울특별시"
    var locality: String = "세종로"
    var address: String {
        "\(administrativeArea) \(locality)"
    }
    
    var temperature: String = "-"
    var currentTemperature: String {
        "\(temperature)°"
    }
    
    var minTemperature: String = "-"
    var maxTemperature: String = "-"
    var minMaxTamperature: String {
        "최저 \(minTemperature)° 최고 \(maxTemperature)°"
    }
    
    var weatherImage: UIImage? = UIImage(systemName: "circle")
    let weatherService = WeatherService()
    
    func mapCurrentData() {
        weatherService.obtainPlacemark { [weak self] placemark in
            guard let self = self else { return }
            
            if let administrativeArea = placemark.administrativeArea,
               let locality = placemark.locality {
                self.administrativeArea = administrativeArea
                self.locality = locality
            }
            self.reloadTableView?()
        }
        
        weatherService.fetchByLocation { [weak self] (currentWeather: CurrentWeatherData) in
            guard let self = self else { return }
            
            if let temperature = currentWeather.mainInformation?.temperature {
                self.temperature = temperature.franctionDisits()
            }
            if let minTemperature = currentWeather.mainInformation?.minimumTemperature {
                self.minTemperature = minTemperature.franctionDisits()
            }
            if let maxTemperature = currentWeather.mainInformation?.maximumTemperature {
                self.maxTemperature = maxTemperature.franctionDisits()
            }
            
            if let iconName = currentWeather.conditions?.first?.iconName {
                ImageLoader.shared.obtainImage(cacheKey: iconName, completion: { image in
                    guard let image = image else {
                        print("Image not found")
                        return
                    }
                    self.weatherImage = image
                    self.reloadTableView?()
                })
            }
        }
    }
}
