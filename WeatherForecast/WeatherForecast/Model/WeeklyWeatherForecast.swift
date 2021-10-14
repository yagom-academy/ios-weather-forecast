//
//  WeeklyWeatherInfo.swift
//  WeatherForecast
//
//  Created by 샬롯, 수박, 루얀 on 2021/09/28.
//

import Foundation

struct WeatherForecast: Codable {
    let forecastedTime: Int?
    let main: WeatherNumericalValue?
    let weather: [WeatherExpression]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let rain: Rain?
    let snow: Snow?
    let formattedForecastedTime: String?
    
    enum CodingKeys: String, CodingKey {
        case main, weather, clouds, wind, visibility, pop, rain, snow
        case forecastedTime = "dt"
        case formattedForecastedTime = "dt_txt"
    }
}

struct WeeklyWeatherForecast: Codable {
    let list: [WeatherForecast]?
    let timestampCount: Int?

    enum CodingKeys: String, CodingKey {
        case list
        case timestampCount = "cnt"
    }
}
