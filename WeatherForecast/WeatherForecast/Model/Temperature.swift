//
//  Temperature.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct Temperature: Codable {
    let currentTemperatrue: Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case currentTemperatrue = "temp"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
    }
}
