//
//  MainInfo.swift
//  WeatherForecast
//
//  Created by Theo on 2021/10/21.
//

import Foundation

struct MainInfo: Decodable {
    let temperature: Double
    let temperatureMin: Double
    let temperatureMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
    }
}
