//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/28.
//

import Foundation

struct CurrentWeather: Decodable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: MainWeatherInfo
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
