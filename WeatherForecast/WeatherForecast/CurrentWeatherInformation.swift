//
//  CurrentWeatherInformation.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct CurrentWeatherInformation: Decodable {
    let city: String
    let coordinates: Coordinates
    let temperature: Temperature
    let icon: WeatherIcon

    enum CodingKeys: String, CodingKey {
        case city = "name"
        case coordinates = "coord"
        case temperature = "main"
        case icon = "weather"
    }
}
