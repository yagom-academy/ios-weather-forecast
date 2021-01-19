//
//  FivedaysForecast.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct FivedaysForecast: Codable {
    let dateTime: Date
    let temperature: Temperature
    let weatherIcon: [WeatherIcon]
    let dataTimeText: Date
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temperature = "main"
        case weatherIcon = "weather"
        case dataTimeText = "dt_txt"
    }
}
