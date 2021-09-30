//
//  WeekWeatherInfo.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/09/28.
//

import Foundation


struct Rain: Codable {
    let volumeForThreeHours: Double
    
    enum CodingKeys: String, CodingKey {
        case volumeForThreeHours = "3h"
    }
}

struct Snow: Codable {
    let volumeForThreeHours: Double
    
    enum CodingKeys: String, CodingKey {
        case volumeForThreeHours = "3h"
    }
}

struct WeeklySys: Codable {
    let pod: String
}

struct WeatherInfo: Codable {
    let forecastedTime: Int
    let main: WeatherNumericalValue
    let weather: [WeatherExpression]
    let clouds: CloudsNumericalValue
    let wind: WindNumericalValue
    let visibility: Int
    let pop: Double
    let rain: Rain
    let snow: Snow
    let sys: WeeklySys
    let formattedForecastedTime: String
    
    enum CodingKeys: String, CodingKey {
        case main, weather, clouds, wind, visibility, pop, rain, snow, sys
        case forecastedTime = "dt"
        case formattedForecastedTime = "dt_txt"
    }
}

struct City: Codable {
    let identifier: Int
    let name: String
    let coordinate: Coordinate
    let country: String
    let timezone: Int
    let sunrise: Int
    let sunset: Int
    
    enum CodingKeys: String, CodingKey {
        case name, country, timezone, sunrise, sunset
        case identifier = "id"
        case coordinate = "coord"
    }
}

struct WeekWeatherInfo: Codable {
    let cod: String
    let message: Int
    let timestampCount: Int
    let list: [WeatherInfo]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case cod, message, list, city
        case timestampCount = "cnt"
    }
}
