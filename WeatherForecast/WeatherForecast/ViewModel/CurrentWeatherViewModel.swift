//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by Soll on 2021/10/13.
//

import UIKit

class CurrentWeatherViewModel {
    
    var administrativeArea: String = "서울특별시"
    var locality: String = "세종로"
    var temperature: String = "-"
    var minTemperature: String = "-"
    var maxTemperature: String = "-"
    var weatherImage: UIImage = UIImage()
    
    let weatherService = WeatherService()
    
    func reload() {
        weatherService.obtainPlacemark { [weak self] placemark in
            guard let self = self else { return }
            
            if let administrativeArea = placemark.administrativeArea,
               let locality = placemark.locality {
                self.administrativeArea = administrativeArea
                self.locality = locality
            }
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
        }
    }
}
