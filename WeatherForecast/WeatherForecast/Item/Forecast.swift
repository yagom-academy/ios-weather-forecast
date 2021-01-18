//
//  Forecast.swift
//  WeatherForecast
//
//  Created by Wonhee on 2021/01/18.
//

import Foundation

struct Forecast: Codable {
    let itemCount: Int
    let list: [ForecastItem]
    let city: [CityInformation]
    
    enum CodingKeys: String, CodingKey {
        case itemCount = "cnt"
        case list
        case city
    }
}
