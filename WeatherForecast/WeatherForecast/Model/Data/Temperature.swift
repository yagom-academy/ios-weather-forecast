//
//  Temperatur.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct Temperature: Decodable {
    let averageTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case averageTemperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
}
