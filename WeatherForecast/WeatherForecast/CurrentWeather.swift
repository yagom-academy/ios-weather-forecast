//
//  test.swift
//  WeatherForecast
//
//  Created by 오승기 on 2021/09/28.
//

import Foundation

struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let cloud: Cloud
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
        case base
        case main
        case visibility
        case wind
        case cloud = "clouds"
        case dt
        case sys
        case timezone
        case id
        case name
        case cod
    }
}
