//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 이학주 on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let weatherIcon: [Weather]
    let city: City
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case weatherIcon = "weather"
        case city = "city"
        case temperature = "main"
    }
}
