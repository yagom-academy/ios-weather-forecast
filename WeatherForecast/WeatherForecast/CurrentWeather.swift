//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 이학주 on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let weatherIcon: [Weather]
    let location: String
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case weatherIcon = "weather"
        case location = "name"
        case temperature = "main"
    }
}
