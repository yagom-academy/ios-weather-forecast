//
//  ForecastWeather.swift
//  WeatherForecast
//
//  Created by Zero DotOne on 2021/01/18.
//

import Foundation

struct ForecastWeather: Codable {
    let list: [CurrentWeather]
    let city: City
}
