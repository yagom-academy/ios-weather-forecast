//
//  FiveDaysWeatherInformation.swift
//  WeatherForecast
//
//  Created by iluxsm on 2021/01/19.
//

import Foundation

struct FiveDaysWeatherInformation: Decodable {
    let count: Int
    let city: CityForAccess
    let list: [ListForAccess]

    enum CodingKeys: String, CodingKey {
        case count = "cnt"
        case city
        case list
    }
}
