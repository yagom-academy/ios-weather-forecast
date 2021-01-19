//
//  CurrentWeatherData.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct CurrentWeather: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let wind: Wind
    let clouds: Clouds?
    let rain: Rain?
    let snow: Snow?
    let dt: Int
    let sys: Sys
    let tinezone: Int
    let id: Int
    let name: String
    let cod: Int
}
