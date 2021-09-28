//
//  FiveDayForecast.swift
//  WeatherForecast
//
//  Created by 이윤주 on 2021/09/28.
//

import Foundation

struct FiveDayForecast: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [List]
    let city: [City]
}
