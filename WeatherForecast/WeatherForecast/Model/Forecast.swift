//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct Forecast: Codable {
    let dateTime: Date
    let icon: [WeatherIcon]
    let temperature: Temperature
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt_txt"
        case icon = "weather"
        case temperature = "main"
    }
}
