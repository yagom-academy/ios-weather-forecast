//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Zero DotOne on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int?
    let id: Int?
    let name: String?
}
