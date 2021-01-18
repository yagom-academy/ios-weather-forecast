//
//  Temperature.swift
//  WeatherForecast
//
//  Created by 김태형 on 2021/01/18.
//

import Foundation

struct Temperature: Codable {
    let currentTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minTemperature = "min_temp"
        case maxTemperature = "max_temp"
    }
}
