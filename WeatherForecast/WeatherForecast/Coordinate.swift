//
//  Coordinate.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct Coordinate: Decodable {
    let longitude: Double
    let latitude: Double

    enum Codingkeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
