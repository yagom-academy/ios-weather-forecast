//
//  ListForAccess.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct ForecastList: Decodable {
    let temperature: Temperature
    private let weatherInformation: [Weather]
    let dateWithHours: String

    var weather: Weather {
        guard let weatherIcon = weatherInformation.first else {
            fatalError("Data is missed.")
        }
        return weatherIcon
    }

    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case weatherInformation
        case dateWithHours = "dt_txt"
    }
}
