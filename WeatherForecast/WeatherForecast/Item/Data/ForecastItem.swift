//
//  ForecastItem.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct ForecastItem: Codable {
    let dateTime: Int64
    let temperatureInformation: Temperature
    let weatherInformation: WeatherInformation
}
