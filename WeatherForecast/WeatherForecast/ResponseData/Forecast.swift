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
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case timestampCount = "cnt"
        case list
        case city
    }
}
