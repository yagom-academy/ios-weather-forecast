//
//  ListForAccess.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct ListForAccess: Decodable {
    let temperature: Temperature
    let weather: [Weather]
    let dateWithHours: String

    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case weather
        case dateWithHours = "dt_txt"
    }
}
