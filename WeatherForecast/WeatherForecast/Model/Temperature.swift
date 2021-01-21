//
//  Temperature.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct Temperature: Decodable {
    let average: Double
    let minimun: Double
    let maximum: Double
    
    enum CodingKeys: String, CodingKey {
        case average = "temp"
        case minimun = "temp_min"
        case maximum = "temp_max"
    }
}
