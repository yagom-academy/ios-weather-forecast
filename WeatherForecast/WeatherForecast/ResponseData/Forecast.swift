//
//  ForecastData.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct Forecast: Codable {
    let list: [CurrentWeather]
    let city: City
}
