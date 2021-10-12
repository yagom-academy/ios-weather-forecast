//
//  IntervalWeatherData.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/09/28.
//

import Foundation

struct IntervalWeatherData: WeatherInformation {
    var conditions: [Condition]?
    var mainInformation: MainInformation?
    let date: TimeInterval?
    let dateText: String?
    
    enum CodingKeys: String, CodingKey {
        case conditions = "weather"
        case mainInformation = "main"
        case date = "dt"
        case dateText = "dt_txt"
    }
}
