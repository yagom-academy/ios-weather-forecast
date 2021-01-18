//
//  ListForAccess.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct ListForAccess: Decodable {
    let temperature: Temperature
    let icon: WeatherIcon
    let dateWithHours: String

    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case icon = "weather"
        case dateWithHours = "dt_txt"
    }
}
