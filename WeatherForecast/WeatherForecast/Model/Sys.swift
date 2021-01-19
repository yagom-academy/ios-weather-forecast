//
//  Sys.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/19.
//

import Foundation

struct Sys: Codable {
    let type: Int
    let id: Int
    let message: Double
    let country: String
    let sunrise: Date
    let sunset: Date
}
