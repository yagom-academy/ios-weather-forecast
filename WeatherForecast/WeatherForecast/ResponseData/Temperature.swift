//
//  Main.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct Temperature: Decodable {
    let celciusAverage: Double
    let celciusMinimum: Double
    let celciusMaximum: Double
    
    enum CodingKeys: String, CodingKey {
        case celciusAverage = "temp"
        case celciusMinimum = "temp_min"
        case celciusMaximum = "temp_max"
    }
}
