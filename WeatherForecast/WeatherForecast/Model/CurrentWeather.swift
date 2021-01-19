//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let coordinate: Coordinate
    let cityName: String
    let icon: [WeatherIcon]
    let temperature: Temperature
    let wind: Wind
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case cityName = "name"
        case icon = "weather"
        case temperature = "main"
        case wind
    }
}
