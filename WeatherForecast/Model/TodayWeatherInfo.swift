//
//  TodayWeatherInfo.swift
//  WeatherForecast
//
//  Created by 이예원 on 2021/09/28.
//

import Foundation

struct WeatherExpression: Codable {
    let identifier: Int
    let main: String
    let body: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case main, icon
        case identifier = "id"
        case body = "description"
    }
}

struct WeatherNumericalValue: Codable {
    let temperature: Double
    let feelsLike: Double
    let minimumTemperature: Double
    let maximumTemperature: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case pressure, humidity
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
    }
}

struct WindNumericalValue: Codable {
    let speed: Double
    let degree: Int
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
    }
}

struct CloudsNumericalValue: Codable {
    let cloudiness: Int
    
    enum CodingKeys: String, CodingKey {
        case cloudiness = "all"
    }
}

struct Sys: Codable {
    let type: Int
    let identifier: Int
    let message: Double
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case type, message, country, sunrise, sunset
        case identifier = "id"
    }
}

struct TodayWeatherInfo: Codable {
    let coordinate: Coordinate
    let weather: [WeatherExpression]
    let base: String
    let main: WeatherNumericalValue
    let visibility: Double
    let wind: WindNumericalValue
    let clouds: CloudsNumericalValue
    let calculatedTime: TimeInterval
    let sys: Sys
    let timezone: Int
    let identifier: Int
    let name: String
    let cod: Int
    
    enum CodingKeys: String, CodingKey {
        case weather, base, main, visibility, wind, clouds, sys, timezone, name, cod
        case coordinate = "coord"
        case calculatedTime = "dt"
        case identifier = "id"
    }
}


