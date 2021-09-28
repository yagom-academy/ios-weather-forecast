//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 홍정아 on 2021/09/28.
//

import Foundation

struct CurrentWeather: Decodable {
    let coordinates: Coordinates
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let calculationTime: Date
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    enum CodingKeys: String, CodingKey {
        case weather, base, main, visibility, wind, clouds, sys, timezone, id, name, cod
        case coordinates = "coord"
        case calculationTime = "dt"
    }
    
    struct Sys: Decodable {
        let type: Int?
        let id: Int?
        let message: Double?
        let country: String?
        let sunrise: Int
        let sunset: Int
    }
}
