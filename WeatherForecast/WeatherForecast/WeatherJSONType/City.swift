//
//  City.swift
//  WeatherForecast
//
//  Created by Zero DotOne on 2021/01/18.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let timezone: Int
}
