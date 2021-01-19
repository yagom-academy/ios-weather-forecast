//
//  ForecastList.swift
//  WeatherForecast
//
//  Created by 김태형 on 2021/01/19.
//

import Foundation

struct ForecastList: Decodable {
    let temperature: Temperature
    let date: String
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case temperature = "main"
        case date = "dt_txt"
        case weather
    }
}
