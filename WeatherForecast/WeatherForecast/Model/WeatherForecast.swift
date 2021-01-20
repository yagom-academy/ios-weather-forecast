//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct WeatherForecast: Decodable {
    let count: Int
    let list: [WeatherForecastItem]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case count = "cnt"
        case list
        case city
    }
}
