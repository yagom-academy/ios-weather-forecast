//
//  City.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let coodinate: Coordinate
    let country: String
    let timezone: Int
    let sunriseTime: TimeInterval
    let sunsetTime: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case id, name, coodinate, country, timezone
        case sunriseTime = "sunrise"
        case sunsetTime = "sunset"
    }
}
