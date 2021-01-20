//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct CurrentWeather: Decodable {
    let addressName: String
    let temperature: Temperature
    let weather: Weather
    
    enum CodingKeys: String, CodingKey {
        case addressName = "name"
        case temperature = "main"
        case weather
    }
}
