//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct Coordinates: Decodable {
    let lon: Double
    let lat: Double

    enum Codingkeys: String, CodingKey {
        case lon = "lon"
        case lat = "lat"
    }
}
