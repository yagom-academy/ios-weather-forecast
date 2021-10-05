//
//  CurrentData.swift
//  WeatherForecast
//
//  Created by Marco, Soll on 2021/09/28.
//

import Foundation

struct CurrentWeatherData: WeatherInformation {
    var conditions: [Condition]?
    var mainInformation: MainInformation?

    enum CodingKeys: String, CodingKey {
        case conditions = "weather"
        case mainInformation = "main"
    }
}
