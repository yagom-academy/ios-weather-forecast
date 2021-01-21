//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by 김지혜 on 2021/01/20.
//

import Foundation

struct Weather: Decodable {
    let dateTime: Int
    let temperature: Temperature
    let main: [MainWeather]
    
    enum CodingKeys: String, CodingKey {
        case dateTime = "dt"
        case temperature = "main"
        case main = "weather"
    }
}

struct Temperature: Decodable {
    let avg: Double
    let min: Double
    let max: Double
    
    enum CodingKeys: String, CodingKey {
        case avg = "temp"
        case min = "temp_min"
        case max = "temp_max"
    }
}

struct MainWeather: Decodable {
    let iconId: String
    let group: String
    let condition: String
    
    enum CodingKeys: String, CodingKey {
        case iconId = "icon"
        case group = "main"
        case condition = "description"
    }
}
