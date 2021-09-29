//
//  WeatherError.swift
//  WeatherForecast
//
//  Created by tae hoon park on 2021/09/29.
//

import Foundation

protocol WeatherCodable {}

extension Int: WeatherCodable {}
extension String: WeatherCodable {}

struct WeatherError {
    let cod: WeatherCodable
    let message: String
}
