//
//  Main.swift
//  WeatherForecast
//
//  Created by Zero DotOne on 2021/01/18.
//

import Foundation

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let temp_min: Double
    let temp_max: Double
}
