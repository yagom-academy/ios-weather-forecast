//
//  FiveDaysWeather.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/28.
//

import Foundation

struct FiveDaysWeather: Decodable {
    let cod: Int
    let message: Int
    let cnt: Int
    let list: [List]
    let city: City
}
