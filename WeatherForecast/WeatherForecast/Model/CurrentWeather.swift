//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let coordinate: Coordinate
    let icon: [WeatherIcon]
    let base: String
    let temperature: Temperature
    let visibility: Double
    let wind: Wind
    let clouds: Clouds
    let timeOfDataCalculation: Date
    let sys: Sys
    let timezone: Double
    let id: Double
    let cityName: String
    let cod: Int
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case icon = "weather"
        case temperature = "main"
        case timeOfDataCalculation = "dt"
        case cityName = "name"
        case base, visibility, wind, clouds, sys, timezone, id, cod
    }
}
