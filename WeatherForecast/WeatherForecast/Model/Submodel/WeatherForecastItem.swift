//
//  WeatherForecastItem.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct WeatherForecastItem: Decodable {
    let temperature: Temperature
    let weather: Weather
    let dateTimeString: String
    
    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case weather
        case dateTimeString = "dt_txt"
    }
}
