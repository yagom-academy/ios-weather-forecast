//
//  WeatherForecastItem.swift
//  WeatherForecast
//
//  Created by Kyungmin Lee on 2021/01/19.
//

import Foundation

struct WeatherForecastItem: Decodable {
    let utc: Int
    let temperature: Temperature
    private let weathers: [Weather]
    let dateTimeString: String
    
    var weather: Weather {
        return weathers[0]
    }
    
    enum CodingKeys: String, CodingKey {
        case utc = "dt"
        case temperature = "main"
        case weathers = "weather"
        case dateTimeString = "dt_txt"
    }
}
