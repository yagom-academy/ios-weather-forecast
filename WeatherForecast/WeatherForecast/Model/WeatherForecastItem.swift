//
//  WeatherForecastItem.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct WeatherForecastItem: Codable {
    let temperature: Temperature
    let weather: Weather
    
    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case weather
    }
}
