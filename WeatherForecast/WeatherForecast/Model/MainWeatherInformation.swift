//
//  MainWeatherInformation.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct MainWeatherInformation: Decodable {
    let temperature: Double
    let feelsLike: Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure, humidity
    }
}
