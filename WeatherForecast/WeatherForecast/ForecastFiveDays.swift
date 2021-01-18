//
//  ForecastFiveDay.swift
//  WeatherForecast
//
//  Created by 김태형 on 2021/01/18.
//

import Foundation

struct ForecastFiveDays: Codable {
    let date: String
    let numberOfTimestamps: Int
    let weather: [Weather]
    let temperature: Temperature
    
    enum CodingKeys:String, CodingKey {
        case date = "dt_txt"
        case numberOfTimestamps = "cnt"
        case weather = "weather"
        case temperature = "main"
    }
}
