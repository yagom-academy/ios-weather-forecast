//
//  Wind.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/19.
//

import Foundation

struct Wind: Codable {
    let speed: Double
    let direction: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
        case direction = "deg"
    }
}
