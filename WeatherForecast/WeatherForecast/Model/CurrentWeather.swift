//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    private let weathers: [Weather]
    let base: String
    let temperature: Temperature
    
    var weather: Weather {
        return weathers[0]
    }
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weathers = "weather"
        case base
        case temperature = "main"
    }
}
