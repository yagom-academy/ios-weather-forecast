//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct FiveDaysForecast: Decodable {
    let itemCount: Int
    let list: [ForecastItem]
    
    enum CodingKeys: String, CodingKey {
        case itemCount = "cnt"
        case list
    }
}
