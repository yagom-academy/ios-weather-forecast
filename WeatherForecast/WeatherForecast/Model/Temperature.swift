//
//  Temperature.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct Temperature: Decodable {
    let average: Double
    let maximum: Double
    let minimum: Double

    enum CodingKeys: String, CodingKey {
        case average = "temp"
        case maximum = "temp_max"
        case minimum = "temp_min"
    }
}
