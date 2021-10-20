//
//  CommonWeatherForecast.swift
//  WeatherForecast
//
//  Created by 김준건 on 2021/09/28.
//

import Foundation

struct Coordinates: Decodable {
    let longitude: Double?
    let latitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Clouds: Decodable {
    let all: Int
}

struct Wind: Decodable {
    let speed: Double
    let degree: Double
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed, gust
        case degree = "deg"
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temperature: Double
    let feelsLikeTemperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let groundLevel: Int?
    let tempKf: Int?
    
    enum CodingKeys: String, CodingKey {
        case pressure, humidity, seaLevel, tempKf
        case temperature = "temp"
        case feelsLikeTemperature = "feels_like"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case groundLevel = "grnd_level"
    }
}

