//
//  ThenWeather.swift
//  WeatherForecast
//
//  Created by 이학주 on 2021/01/19.
//

import Foundation

struct ThenWeather: Codable {
    let date: String
    let temperature: Temperature
    let weatherIcon: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt_txt"
        case temperature = "main"
        case weatherIcon = "weather"
    }
}
