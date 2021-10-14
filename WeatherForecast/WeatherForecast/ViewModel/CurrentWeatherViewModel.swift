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
                print("현재 주소: \(administrativeArea), \(locality)")
            }
        }
        
        weatherService.fetchByLocation { [weak self] (currentWeather: CurrentWeatherData) in
            guard let self = self else { return }
            
            if let temperature = currentWeather.mainInformation?.temperature {
                self.temperature = temperature.franctionDisits()
                print("현재 온도: \(temperature.franctionDisits())")
            }
            if let minTemperature = currentWeather.mainInformation?.minimumTemperature {
                self.minTemperature = minTemperature.franctionDisits()
                print("최저 온도: \(minTemperature.franctionDisits())")
            }
            if let maxTemperature = currentWeather.mainInformation?.maximumTemperature {
                self.maxTemperature = maxTemperature.franctionDisits()
                print("최고 온도: \(maxTemperature.franctionDisits())")
            }
        }
    }
}
