//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let cityName: String
    let icon: WeatherIcon
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case icon = "weather"
        case temperature = "main"
    }
}
