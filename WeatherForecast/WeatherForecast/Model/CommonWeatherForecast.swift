//
//  CommonWeatherForecast.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/09/28.
//

import Foundation

struct Coordinates: Decodable {
    let longitude: Double
    let latitude: Double
}

struct Clouds: Decodable {
    let all: Int
}

struct Wind: Decodable {
    let speed: Double
    let degree: Double
    let gust: Double?
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?
    let tempKf: Int?
}

