//
//  Main.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let temp_min: Double
    let temp_max: Double
    let sea_level: Int
    let grnd_level: Int
}
