//
//  FiveDaysWeatherInformation.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct FiveDaysForecast: Decodable {
    let listCount: Int
    let city: CityInformation
    let list: [ForecastList]

    enum CodingKeys: String, CodingKey {
        case listCount = "cnt"
        case city
        case list
    }
}
