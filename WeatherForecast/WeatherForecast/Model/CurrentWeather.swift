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
    let temperature: Temperature
    let utc: Int
    let cityID: Int
    let cityName: String
    
    var weather: Weather {
        return weathers[0]
    }
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weathers = "weather"
        case temperature = "main"
        case utc = "dt"
        case cityID = "id"
        case cityName = "name"
    }
}
