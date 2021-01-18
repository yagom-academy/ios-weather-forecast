//
//  FiveDaysWeather.swift
//  WeatherForecast
//
//  Created by 이학주 on 2021/01/19.
//

import Foundation

struct FiveDaysWeather: Codable {
    let forecastList: [ThenWeather]
}
