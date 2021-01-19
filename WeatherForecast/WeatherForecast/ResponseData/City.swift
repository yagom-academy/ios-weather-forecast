//
//  List.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct City: Codable {
    let name: String
    let coord: Coord
    let timezone: Int
}
