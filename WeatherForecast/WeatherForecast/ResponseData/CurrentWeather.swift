//
//  CurrentWeatherData.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let temperature: Temperature
    let timezone: Int
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case temperature = "main"
        case timezone
        case cityName = "name"
    }
}
