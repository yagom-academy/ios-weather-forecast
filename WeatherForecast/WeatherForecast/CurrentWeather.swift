//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김태형 on 2021/01/18.
//

import Foundation

struct CurrentWeather: Decodable {
    let city: String
    let temperature: Temperature
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case city = "name"
        case temperature = "main"
        case weather = "weather"
    }
}
