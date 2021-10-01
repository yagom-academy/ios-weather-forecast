//
//  FiveDayData.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/09/28.
//

import Foundation

struct FiveDayData: Codable {
    let cod: String?
    let message: Int?
    let countOfTimestamps: Int?
    let weatherList: [IntervalData]?
    let city: City?
    
    enum CodingKeys: String, CodingKey {
        case cod, message, city
        case countOfTimestamps = "cnt"
        case weatherList = "list"
    }
}

struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coordinate?
    let country: String?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}
