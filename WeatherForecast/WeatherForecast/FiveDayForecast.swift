//
//  FiveDayForecast.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/09/28.
//

import Foundation

struct FiveDayForecast: Decodable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let list: [List]
    let city: City
}

struct List: Decodable {
    let date: Int
    let main: Main
    let weather: [Weather]
    let cloud: Cloud?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let rain: Rain?
    let snow: Snow?
    let sys: Sys?
    let dateText: String?
    
    struct Sys: Decodable {
        let dayOrNight: String?
        
        enum CodingKeys: String, CodingKey {
            case dayOrNight = "pod"
        
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case main, weather, wind, visibility, pop, rain, snow, sys
        case date = "dt"
        case cloud = "clouds"
        case dateText = "dt_txt"
    }
}

struct City: Decodable {
    let id: Int
    let name: String?
    let coordinate: Coordinate?
    let country: String?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, country, timezone, sunrise, sunset
        case coordinate = "coord"
    }
}
