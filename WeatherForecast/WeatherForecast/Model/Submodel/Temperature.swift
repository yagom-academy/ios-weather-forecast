//
//  Temperature.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct Temperature: Decodable {
    let current: Double
    let humanFeels: Double
    let minimum: Double
    let maximum: Double
    let atmosphericPressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case current = "temp"
        case humanFeels = "feels_like"
        case minimum = "temp_min"
        case maximum = "temp_max"
        case atmosphericPressure = "pressure"
        case humidity
    }
}
