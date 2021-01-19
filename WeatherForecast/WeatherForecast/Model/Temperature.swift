//
//  Temperature.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct Temperature: Codable {
    let average: Double
    let minimun: Double
    let maximum: Double
    let humanFeel: Double
    let pressure: Double
    let humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case average = "temp"
        case minimun = "temp_min"
        case maximum = "temp_max"
        case humanFeel = "feels_like"
        case pressure, humidity 
    }
}
