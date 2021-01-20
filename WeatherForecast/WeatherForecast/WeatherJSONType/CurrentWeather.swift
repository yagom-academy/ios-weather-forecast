//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Zero DotOne on 2021/01/18.
//

import Foundation

struct CurrentWeather: Codable {
    let coord: Coord?
    let weather: [Weather]
    let base: String?
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let dateTime: Int
    let local: Local
    let timezone: Int?
    let id: Int?
    let name: String?
    let visibility: Int
    
    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case base
        case main
        case wind
        case clouds
        case dateTime = "dt"
        case local = "sys"
        case timezone
        case id
        case name
        case visibility
    }
}
