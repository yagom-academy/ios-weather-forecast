//
//  Temperature.swift
//  WeatherForecast
//
//  Created by 이학주 on 2021/01/18.
//

import Foundation

struct Temperature: Codable {
    let currentTemperature: Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minimumTemperature = "min_temp"
        case maximumTemperature = "max_temp"
    }
}
