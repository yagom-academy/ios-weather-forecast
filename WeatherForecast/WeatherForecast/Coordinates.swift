//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct Coordinates: Decodable {
    let longitude: Double
    let latitude: Double

    enum Codingkeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
