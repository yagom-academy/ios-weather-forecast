//
//  FiveDayWeatherForecast.swift
//  WeatherForecast
//
//  Created by JINHONG AN on 2021/09/28.
//

import Foundation

struct FiveDayWeatherForecast: Decodable {
    let statusCode: String?
    let message: Int?
    let numberOfTimeStamps: Int?
    let weatherForFiveDays: [WeatherForOneDay]?
    let city: City?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "cod"
        case message, city
        case numberOfTimeStamps = "cnt"
        case weatherForFiveDays = "list"
    }
}
