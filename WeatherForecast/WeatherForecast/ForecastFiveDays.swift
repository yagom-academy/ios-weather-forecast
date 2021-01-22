//
//  ForecastFiveDay.swift
//  WeatherForecast
//
//  Created by 김태형 on 2021/01/18.
//

import Foundation

struct ForecastFiveDays: Decodable {
    let numberOfTimestamps: Int
    let list: [ForecastList]
    
    enum CodingKeys: String, CodingKey {
        case numberOfTimestamps = "cnt"
        case list
    }
}
