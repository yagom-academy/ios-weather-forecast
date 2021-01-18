//
//  ForecastItem.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct ForecastItem: Codable {
    let dateTime: Int64
    let temperature: Temperature
    let weather: WeatherInformation
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temperature = "main"
        case weather
    }
}
