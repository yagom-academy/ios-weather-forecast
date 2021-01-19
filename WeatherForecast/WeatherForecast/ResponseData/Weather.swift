//
//  Weather.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon : String
}
