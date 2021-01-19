//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    let weather: [Weather]
    let temperature: Temperature
    let base: String
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
        case temperature = "main"
        case base
    }
}
