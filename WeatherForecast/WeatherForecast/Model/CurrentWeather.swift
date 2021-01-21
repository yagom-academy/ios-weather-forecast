//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct CurrentWeather: Decodable {
    let icon: [WeatherIcon]
    let temperature: Temperature
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case icon = "weather"
        case temperature = "main"
        case cityName = "name"
    }
}
