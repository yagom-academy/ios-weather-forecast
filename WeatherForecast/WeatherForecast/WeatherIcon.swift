//
//  WeatherIcon.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct WeatherIcon: Decodable {
    let code: String

    enum CodingKeys: String, CodingKey {
        case code = "icon"
    }
}
