//
//  CurrentWeatherData.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct CurrentWeather: Decodable {
    let weatherIcon: [WeatherIcon]
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case weatherIcon = "weather"
        case temperature = "main"
    }
}
