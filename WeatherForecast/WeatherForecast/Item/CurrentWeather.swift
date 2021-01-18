//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let addressName: String
    let temperature: TemperatureInformation
    let weather: WeatherInformation
    
    enum CodingKeys: String, CodingKey {
        case addressName = "name"
        case temperature = "main"
        case weather
    }
}
