//
//  Temperature.swift
//  WeatherForecast
//
//  Created by 임성민 on 2021/01/21.
//

import Foundation

struct Temperature: Decodable {
    let value: Double
    let feelsLikeValue: Double
    let minimumValue: Double
    let maximumValue: Double
    let kfValue: Double?
}
