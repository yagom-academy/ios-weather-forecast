//
//  WeatherInformation.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/09/28.
//

import Foundation

protocol WeatherInformation {
    
}

struct Coordinate {
    let lon: Double?
    let lat: Double?
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct MainInformation: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let grndLevel: Int?
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

struct Clouds: Codable {
    let all: Int?
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
    let pod: String?
}

struct Rain {
    let oneHour: Int?
    let threeHours: Int?
}

struct Snow {
    let oneHour: Int?
    let threeHours: Int?
}
