//
//  FivedaysForecast.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct FivedaysForecast: Decodable {
    let temperature: Temperature
    let weatherIcon: [WeatherIcon]
    let dateTimeText: String
    
    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case weatherIcon = "weather"
        case dateTimeText = "dt_txt"
    }
}
