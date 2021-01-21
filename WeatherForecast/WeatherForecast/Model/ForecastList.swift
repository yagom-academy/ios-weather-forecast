//
//  ForecastList.swift
//  WeatherForecast
//
//  Created by Yeon on 2021/01/18.
//

import Foundation

struct ForecastList: Decodable {
    let list: [Forecast]
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case list
        case count = "cnt"
    }
}
