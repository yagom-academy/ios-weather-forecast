//
//  FivedaysForecastWeathers.swift
//  WeatherForecast
//
//  Created by 김지혜 on 2021/01/20.
//

import Foundation

struct FivedaysForecastWeathers: Decodable {
    let code: String
    let message: Double
    let count: Int
    let weathers: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case message
        case count = "cnt"
        case weathers = "list"
    }
}
