//
//  Temperature.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct Temperature: Decodable {
    let currentCelsius: Double
    let humanFeelsCelsius: Double
    let minimumCelsius: Double
    let maximumCelsius: Double
    let atmosphericPressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case currentCelsius = "temp"
        case humanFeelsCelsius = "feels_like"
        case minimumCelsius = "temp_min"
        case maximumCelsius = "temp_max"
        case atmosphericPressure = "pressure"
        case humidity
    }
}
