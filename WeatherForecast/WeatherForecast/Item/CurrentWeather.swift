//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let addressName: String
    let temperatureInformation: Temperature
    let weatherInformation: WeatherInformation
    
    enum CodingKeys: String, CodingKey {
        case addressName = "name"
        case temperatureInformation = "main"
        case weatherInformation = "weather"
    }
}
