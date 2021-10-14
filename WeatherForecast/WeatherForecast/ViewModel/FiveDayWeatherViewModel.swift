//
//  FiveDayWeatherViewModel.swift
//  WeatherForecast
//
//  Created by Soll on 2021/10/14.
//

import Foundation

class FiveDayWeatherViewModel {
    
    var intervalDate: [String] = []
    var intervalTemperature: [String] = []
    
    let weatherService = WeatherService()
    
    func reload() {
        weatherService.fetchByLocation { (fiveDayWeather: FiveDayWeatherData) in
            if let temperature = fiveDayWeather.intervalWeathers?.first?.mainInformation?.temperature {
                print("5일치 날씨 중 첫번째 온도: \(temperature.franctionDisits())")
            }
            
            if let date = fiveDayWeather.intervalWeathers?.first?.date {
                print("5일치 날씨 중 첫번째 날짜: \(date.format(locale: Locale.current))")
            }
        }
    }
}
