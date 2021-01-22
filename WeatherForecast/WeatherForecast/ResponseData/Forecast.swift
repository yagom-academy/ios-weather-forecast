//
//  ForecastData.swift
//  WeatherForecast
//
//  Created by sole on 2021/01/19.
//

import Foundation

struct Forecast: Decodable {
    let timestampCount: Int
    let list: [FivedaysForecast]
    
    enum CodingKeys: String, CodingKey {
        case timestampCount = "cnt"
        case list
    }
}
